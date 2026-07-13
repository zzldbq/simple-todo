"""Simple Todo 的 Supabase 云端任务客户端。

只使用 Python 标准库，避免为 Windows 打包额外引入第三方依赖。
"""

from __future__ import annotations

import json
from datetime import datetime
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


class CloudTaskError(RuntimeError):
    """云端请求失败。"""


class CloudTaskClient:
    def __init__(self, url: str, publishable_key: str) -> None:
        self.url = url.rstrip("/")
        self.publishable_key = publishable_key
        self.access_token = ""
        self.user_email = ""
        self.user_id = ""

    @property
    def signed_in(self) -> bool:
        return bool(self.access_token)

    def sign_in(self, email: str, password: str) -> None:
        payload = self._request(
            "POST",
            "/auth/v1/token",
            query={"grant_type": "password"},
            body={"email": email, "password": password},
            authenticated=False,
        )
        token = payload.get("access_token")
        if not isinstance(token, str) or not token:
            raise CloudTaskError("登录成功但没有返回访问令牌。")
        user = payload.get("user")
        user_id = user.get("id") if isinstance(user, dict) else None
        if not isinstance(user_id, str) or not user_id:
            raise CloudTaskError("登录成功但没有返回用户 ID。")
        self.access_token = token
        self.user_email = email
        self.user_id = user_id

    def list_tasks(self) -> list[dict[str, Any]]:
        rows = self._request(
            "GET",
            "/rest/v1/tasks",
            query={"select": "*", "order": "created_at.desc"},
        )
        if not isinstance(rows, list):
            raise CloudTaskError("云端任务返回格式不正确。")
        return [cloud_row_to_task(row) for row in rows]

    def add_task(self, task: dict[str, Any]) -> dict[str, Any]:
        rows = self._request(
            "POST",
            "/rest/v1/tasks",
            query={"select": "*"},
            body=task_to_cloud_insert(task, self.user_id),
            extra_headers={"Prefer": "return=representation"},
        )
        return _single_task(rows)

    def update_task(self, task: dict[str, Any]) -> dict[str, Any]:
        rows = self._request(
            "PATCH",
            "/rest/v1/tasks",
            query={"id": f"eq.{task['id']}", "select": "*"},
            body=task_to_cloud_update(task),
            extra_headers={"Prefer": "return=representation"},
        )
        return _single_task(rows)

    def delete_task(self, task_id: str) -> None:
        self._request(
            "DELETE",
            "/rest/v1/tasks",
            query={"id": f"eq.{task_id}"},
            expect_json=False,
        )

    def _request(
        self,
        method: str,
        path: str,
        *,
        query: dict[str, str] | None = None,
        body: dict[str, Any] | None = None,
        authenticated: bool = True,
        extra_headers: dict[str, str] | None = None,
        expect_json: bool = True,
    ) -> Any:
        target = f"{self.url}{path}"
        if query:
            target = f"{target}?{urlencode(query)}"

        headers = {
            "apikey": self.publishable_key,
            "Content-Type": "application/json",
        }
        if authenticated:
            if not self.access_token:
                raise CloudTaskError("请先登录。")
            headers["Authorization"] = f"Bearer {self.access_token}"
        if extra_headers:
            headers.update(extra_headers)

        data = None
        if body is not None:
            data = json.dumps(body).encode("utf-8")

        request = Request(target, data=data, headers=headers, method=method)
        try:
            with urlopen(request, timeout=15) as response:
                raw = response.read().decode("utf-8")
        except HTTPError as error:
            raw = error.read().decode("utf-8", errors="replace")
            raise CloudTaskError(_format_error(raw, error.code)) from error
        except URLError as error:
            raise CloudTaskError(f"无法连接云端：{error.reason}") from error

        if not expect_json or not raw:
            return None
        try:
            return json.loads(raw)
        except json.JSONDecodeError as error:
            raise CloudTaskError(f"云端返回了无法解析的数据：{raw[:120]}") from error


def task_to_cloud_insert(task: dict[str, Any], user_id: str) -> dict[str, Any]:
    return {
        "user_id": user_id,
        "title": task["title"],
        "due_at": _task_due_to_iso(task),
        "reminder": bool(task.get("reminder")),
        "completed": bool(task.get("completed")),
        "notified": bool(task.get("notified")),
    }


def task_to_cloud_update(task: dict[str, Any]) -> dict[str, Any]:
    return {
        "title": task["title"],
        "due_at": _task_due_to_iso(task),
        "reminder": bool(task.get("reminder")),
        "completed": bool(task.get("completed")),
        "notified": bool(task.get("notified")),
    }


def cloud_row_to_task(row: dict[str, Any]) -> dict[str, Any]:
    due_at = row.get("due_at")
    date_text = ""
    time_text = ""
    if isinstance(due_at, str) and due_at:
        due = datetime.fromisoformat(due_at.replace("Z", "+00:00")).astimezone()
        date_text = due.strftime("%Y-%m-%d")
        time_text = due.strftime("%H:%M")

    return {
        "id": row["id"],
        "title": row["title"],
        "date": date_text,
        "time": time_text,
        "reminder": bool(row.get("reminder")),
        "completed": bool(row.get("completed")),
        "notified": bool(row.get("notified")),
    }


def _task_due_to_iso(task: dict[str, Any]) -> str | None:
    date_text = str(task.get("date") or "")
    time_text = str(task.get("time") or "")
    if not date_text or not time_text:
        return None
    due = datetime.strptime(f"{date_text} {time_text}", "%Y-%m-%d %H:%M")
    return due.astimezone().isoformat()


def _single_task(rows: Any) -> dict[str, Any]:
    if not isinstance(rows, list) or len(rows) != 1:
        raise CloudTaskError("云端没有返回预期的任务数据。")
    return cloud_row_to_task(rows[0])


def _format_error(raw: str, status_code: int) -> str:
    try:
        payload = json.loads(raw)
    except json.JSONDecodeError:
        return f"云端请求失败（HTTP {status_code}）：{raw[:160]}"
    message = payload.get("message") or payload.get("error_description") or raw
    return f"云端请求失败（HTTP {status_code}）：{message}"
