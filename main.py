"""简单待办应用的启动入口。"""

import json
import os
import sys
import tkinter as tk
from datetime import datetime
from pathlib import Path
from tkinter import messagebox, ttk
from uuid import uuid4

from cloud_config import load_cloud_config
from cloud_tasks import CloudTaskClient, CloudTaskError


BG = "#F6F7FB"
CARD = "#FFFFFF"
TEXT = "#1F2937"
MUTED = "#6B7280"
BLUE = "#4F6BED"
BORDER = "#E5E7EB"


def get_data_file() -> Path:
    """开发时保存在项目中，打包后保存在当前用户的数据目录。"""
    if getattr(sys, "frozen", False):
        base = Path(os.getenv("LOCALAPPDATA", Path.home())) / "SimpleTodo"
        base.mkdir(parents=True, exist_ok=True)
        return base / "tasks.json"
    return Path(__file__).with_name("tasks.json")


DATA_FILE = get_data_file()


class TodoApp:
    def __init__(self, window: tk.Tk) -> None:
        self.window = window
        self.window.title("简单待办")
        self.window.geometry("1200x800")
        self.window.minsize(960, 640)
        self.window.configure(bg=BG)
        self.tasks: list[dict] = []
        self.editing_task_id: str | None = None
        self.current_filter = "all"
        self.nav_buttons: dict[str, tk.Button] = {}
        self.cloud_config = load_cloud_config()
        self.cloud_client: CloudTaskClient | None = None

        self._configure_styles()
        self._build_layout()
        self._load_tasks()
        self.window.after(1000, self._check_reminders)

    def _configure_styles(self) -> None:
        style = ttk.Style()
        style.theme_use("clam")
        style.configure("Task.Treeview", background=CARD, fieldbackground=CARD,
                        foreground=TEXT, rowheight=48, borderwidth=0,
                        font=("Microsoft YaHei UI", 10))
        style.configure("Task.Treeview.Heading", background="#F9FAFB",
                        foreground=MUTED, relief="flat",
                        font=("Microsoft YaHei UI", 9, "bold"))
        style.map("Task.Treeview", background=[("selected", "#EAF0FF")],
                  foreground=[("selected", TEXT)])

    def _build_layout(self) -> None:
        sidebar = tk.Frame(self.window, bg=CARD, width=230,
                           highlightbackground=BORDER, highlightthickness=1)
        sidebar.pack(side="left", fill="y")
        sidebar.pack_propagate(False)

        tk.Label(sidebar, text="▣  简单待办", bg=CARD, fg=TEXT,
                 font=("Microsoft YaHei UI", 17, "bold"),
                 anchor="w", padx=24, pady=26).pack(fill="x")

        for text, filter_name in (("☰  全部任务", "all"), ("◷  今天", "today"),
                                  ("✓  已完成", "completed")):
            button = tk.Button(
                sidebar, text=text, relief="flat", anchor="w", padx=28, pady=15,
                cursor="hand2", font=("Microsoft YaHei UI", 11),
                command=lambda name=filter_name: self.set_filter(name),
            )
            button.pack(fill="x", padx=12, pady=3)
            self.nav_buttons[filter_name] = button
        self._update_navigation()

        account = tk.Frame(sidebar, bg=CARD, padx=18, pady=18)
        account.pack(side="bottom", fill="x")
        tk.Label(account, text="云同步账号", bg=CARD, fg=TEXT,
                 font=("Microsoft YaHei UI", 10, "bold"),
                 anchor="w").pack(fill="x", pady=(0, 8))
        self.email_entry = tk.Entry(account, bg=CARD, fg=TEXT,
                                    relief="flat", highlightbackground=BORDER,
                                    highlightthickness=1,
                                    font=("Microsoft YaHei UI", 9))
        self.email_entry.insert(0, "邮箱")
        self._add_placeholder(self.email_entry, "邮箱")
        self.email_entry.pack(fill="x", ipady=6, pady=(0, 8))
        self.password_entry = tk.Entry(account, bg=CARD, fg=TEXT, show="*",
                                       relief="flat", highlightbackground=BORDER,
                                       highlightthickness=1,
                                       font=("Microsoft YaHei UI", 9))
        self.password_entry.pack(fill="x", ipady=6, pady=(0, 8))
        self.cloud_status = tk.Label(account, text="未登录", bg=CARD, fg=MUTED,
                                     anchor="w",
                                     font=("Microsoft YaHei UI", 9))
        self.cloud_status.pack(fill="x", pady=(0, 8))
        self.login_button = tk.Button(
            account, text="登录并同步", bg=BLUE, fg="white",
            activebackground="#3F58D8", activeforeground="white",
            relief="flat", cursor="hand2", pady=7,
            font=("Microsoft YaHei UI", 9, "bold"), command=self.login_cloud,
        )
        self.login_button.pack(fill="x", pady=(0, 6))
        self.refresh_button = tk.Button(
            account, text="刷新云端任务", bg=CARD, fg=BLUE,
            relief="flat", cursor="hand2", pady=5,
            font=("Microsoft YaHei UI", 9), command=self.refresh_cloud_tasks,
        )
        self.refresh_button.pack(fill="x")
        if not self.cloud_config.configured:
            self.login_button.configure(state="disabled")
            self.refresh_button.configure(state="disabled")
            self.cloud_status.configure(text="未配置 Supabase")

        main = tk.Frame(self.window, bg=BG)
        main.pack(side="left", fill="both", expand=True, padx=42, pady=30)

        header = tk.Frame(main, bg=BG)
        header.pack(fill="x", pady=(0, 22))
        tk.Label(header, text="我的任务", bg=BG, fg=TEXT,
                 font=("Microsoft YaHei UI", 25, "bold")).pack(side="left")
        self.search_entry = tk.Entry(
            header, bg=CARD, fg=MUTED, relief="flat",
            font=("Microsoft YaHei UI", 10), width=26,
            highlightbackground=BORDER, highlightthickness=1,
        )
        self.search_entry.insert(0, "搜索任务")
        self._add_placeholder(self.search_entry, "搜索任务")
        self.search_entry.bind("<KeyRelease>", lambda _event: self.refresh_task_list())
        self.search_entry.pack(side="right", ipady=10)

        form = tk.Frame(main, bg=CARD, highlightbackground=BORDER,
                        highlightthickness=1, padx=24, pady=22)
        form.pack(fill="x", pady=(0, 24))

        self.task_entry = tk.Entry(form, bg=CARD, fg=TEXT,
                                   font=("Microsoft YaHei UI", 11), relief="flat",
                                   highlightbackground=BORDER, highlightthickness=1)
        self.task_entry.insert(0, "输入新任务…")
        self._add_placeholder(self.task_entry, "输入新任务…")
        self.task_entry.pack(fill="x", ipady=11, pady=(0, 15))

        controls = tk.Frame(form, bg=CARD)
        controls.pack(fill="x")
        self.date_entry = self._field(controls, "日期：YYYY-MM-DD", 18)
        self.time_entry = self._field(controls, "时间：HH:MM", 14)
        self.reminder = tk.BooleanVar(value=False)
        tk.Checkbutton(controls, text="提醒我", variable=self.reminder,
                       bg=CARD, fg=TEXT, activebackground=CARD,
                       font=("Microsoft YaHei UI", 10)).pack(side="left", padx=14)
        self.add_button = tk.Button(
            controls, text="添加任务", bg=BLUE, fg="white",
            activebackground="#3F58D8", activeforeground="white",
            relief="flat", cursor="hand2", padx=24, pady=10,
            font=("Microsoft YaHei UI", 10, "bold"), command=self.add_task,
        )
        self.add_button.pack(side="right")

        list_card = tk.Frame(main, bg=CARD, highlightbackground=BORDER,
                             highlightthickness=1)
        # 为固定在底部的状态栏预留空间。
        list_card.pack(fill="both", expand=True, pady=(0, 48))

        columns = ("task", "due", "status")
        self.task_list = ttk.Treeview(list_card, columns=columns,
                                      show="headings", style="Task.Treeview")
        self.task_list.heading("task", text="任务")
        self.task_list.heading("due", text="日期与时间")
        self.task_list.heading("status", text="状态")
        self.task_list.column("task", width=440)
        self.task_list.column("due", width=210, anchor="center")
        self.task_list.column("status", width=120, anchor="center")
        self.task_list.pack(fill="both", expand=True, padx=1, pady=1)

        footer = tk.Frame(main, bg=BG)
        footer.place(relx=0, rely=1, relwidth=1, anchor="sw")
        self.count_label = tk.Label(footer, text="0 个任务", bg=BG, fg=MUTED,
                                    font=("Microsoft YaHei UI", 10))
        self.count_label.pack(side="left")
        tk.Button(footer, text="删除", command=self.delete_task,
                  bg=BG, fg="#DC2626", relief="flat", cursor="hand2",
                  font=("Microsoft YaHei UI", 9), padx=10).pack(side="right")
        tk.Button(footer, text="标记完成", command=self.toggle_completed,
                  bg=BG, fg=BLUE, relief="flat", cursor="hand2",
                  font=("Microsoft YaHei UI", 9), padx=10).pack(side="right")
        tk.Button(footer, text="编辑", command=self.start_edit,
                  bg=BG, fg=BLUE, relief="flat",
                  cursor="hand2", font=("Microsoft YaHei UI", 9),
                  padx=10).pack(side="right")

        self.task_entry.bind("<Return>", lambda _event: self.add_task())

    def add_task(self) -> None:
        title = self.task_entry.get().strip()
        date_text = self.date_entry.get().strip()
        time_text = self.time_entry.get().strip()

        if not title or title == "输入新任务…":
            messagebox.showwarning("缺少任务", "请先输入任务内容。")
            self.task_entry.focus_set()
            return

        date_text = "" if date_text == "日期：YYYY-MM-DD" else date_text
        time_text = "" if time_text == "时间：HH:MM" else time_text

        if date_text:
            try:
                datetime.strptime(date_text, "%Y-%m-%d")
            except ValueError:
                messagebox.showwarning("日期格式错误", "日期请按 YYYY-MM-DD 填写。")
                return
        if time_text:
            try:
                datetime.strptime(time_text, "%H:%M")
            except ValueError:
                messagebox.showwarning("时间格式错误", "时间请按 HH:MM 填写。")
                return
        if time_text and not date_text:
            messagebox.showwarning("缺少日期", "设置提醒时间时也需要填写日期。")
            return
        if self.reminder.get() and (not date_text or not time_text):
            messagebox.showwarning("提醒信息不完整", "启用提醒时必须同时填写日期和时间。")
            return
        if self.reminder.get() and date_text and time_text:
            reminder_time = datetime.strptime(
                f"{date_text} {time_text}", "%Y-%m-%d %H:%M"
            )
            if reminder_time <= datetime.now():
                messagebox.showwarning("提醒时间已过去", "请设置一个未来的提醒时间。")
                return

        if self.editing_task_id:
            task = next(task for task in self.tasks
                        if task["id"] == self.editing_task_id)
            task.update({
                "title": title,
                "date": date_text,
                "time": time_text,
                "reminder": self.reminder.get(),
                "notified": False,
            })
            self._persist_task(task)
            self.refresh_task_list()
            self._reset_form()
            return

        task = {
            "id": uuid4().hex,
            "title": title,
            "date": date_text,
            "time": time_text,
            "reminder": self.reminder.get(),
            "completed": False,
            "notified": False,
        }
        if self._cloud_signed_in():
            try:
                task = self.cloud_client.add_task(task)  # type: ignore[union-attr]
            except CloudTaskError as error:
                messagebox.showerror("云端添加失败", str(error))
                return
        self.tasks.append(task)
        if not self._cloud_signed_in():
            self._save_tasks()
        self.refresh_task_list()
        self._reset_form()
        self._update_count()

    def _show_task(self, task: dict) -> None:
        due = " ".join(part for part in (task["date"], task["time"]) if part)
        self.task_list.insert("", "end", iid=task["id"],
                              values=(task["title"], due or "无截止时间",
                                      "已完成" if task["completed"] else "未完成"))

    def set_filter(self, filter_name: str) -> None:
        self.current_filter = filter_name
        self._update_navigation()
        self.refresh_task_list()

    def _update_navigation(self) -> None:
        for name, button in self.nav_buttons.items():
            active = name == self.current_filter
            button.configure(
                bg="#EAF0FF" if active else CARD,
                fg=BLUE if active else TEXT,
                activebackground="#EAF0FF" if active else BG,
                font=("Microsoft YaHei UI", 11, "bold" if active else "normal"),
            )

    def refresh_task_list(self) -> None:
        self.task_list.delete(*self.task_list.get_children())
        query = self.search_entry.get().strip().lower()
        if query == "搜索任务":
            query = ""
        today = datetime.now().strftime("%Y-%m-%d")
        for task in self.tasks:
            if query and query not in task["title"].lower():
                continue
            if self.current_filter == "today" and task["date"] != today:
                continue
            if self.current_filter == "completed" and not task["completed"]:
                continue
            self._show_task(task)

    def _selected_task(self) -> dict | None:
        selected = self.task_list.selection()
        if not selected:
            messagebox.showinfo("请选择任务", "请先在列表中选择一条任务。")
            return None
        task_id = selected[0]
        return next((task for task in self.tasks if task["id"] == task_id), None)

    def toggle_completed(self) -> None:
        task = self._selected_task()
        if task is None:
            return
        task["completed"] = not task["completed"]
        self._persist_task(task)
        self.refresh_task_list()

    def start_edit(self) -> None:
        task = self._selected_task()
        if task is None:
            return
        self.editing_task_id = task["id"]
        for entry, value in ((self.task_entry, task["title"]),
                             (self.date_entry, task["date"]),
                             (self.time_entry, task["time"])):
            entry.delete(0, "end")
            entry.insert(0, value)
            entry.configure(fg=TEXT)
        self.reminder.set(task["reminder"])
        self.add_button.configure(text="保存修改")
        self.task_entry.focus_set()

    def delete_task(self) -> None:
        task = self._selected_task()
        if task is None:
            return
        if not messagebox.askyesno("确认删除", f"确定删除“{task['title']}”吗？"):
            return
        if self._cloud_signed_in():
            try:
                self.cloud_client.delete_task(task["id"])  # type: ignore[union-attr]
            except CloudTaskError as error:
                messagebox.showerror("云端删除失败", str(error))
                return
        self.tasks.remove(task)
        self.task_list.delete(task["id"])
        if not self._cloud_signed_in():
            self._save_tasks()
        self._update_count()

    def _load_tasks(self) -> None:
        if not DATA_FILE.exists():
            return
        try:
            data = json.loads(DATA_FILE.read_text(encoding="utf-8"))
            if not isinstance(data, list):
                raise ValueError("任务数据不是列表")
            self.tasks = data
            for task in self.tasks:
                task.setdefault("reminder", False)
                task.setdefault("completed", False)
                task.setdefault("notified", False)
                self._show_task(task)
            self._update_count()
        except (OSError, ValueError, KeyError, json.JSONDecodeError) as error:
            messagebox.showerror("读取失败", f"无法读取保存的任务：\n{error}")

    def _save_tasks(self) -> None:
        try:
            DATA_FILE.write_text(
                json.dumps(self.tasks, ensure_ascii=False, indent=2),
                encoding="utf-8",
            )
        except OSError as error:
            messagebox.showerror("保存失败", f"无法保存任务：\n{error}")

    def login_cloud(self) -> None:
        email = self.email_entry.get().strip()
        password = self.password_entry.get()
        if not email or email == "邮箱" or not password:
            messagebox.showwarning("缺少账号", "请输入邮箱和密码。")
            return
        self.cloud_status.configure(text="正在登录…")
        self.window.update_idletasks()
        client = CloudTaskClient(
            self.cloud_config.url,
            self.cloud_config.publishable_key,
        )
        try:
            client.sign_in(email, password)
        except CloudTaskError as error:
            self.cloud_status.configure(text="登录失败")
            messagebox.showerror("登录失败", str(error))
            return

        self.cloud_client = client
        self.cloud_status.configure(text=f"已登录：{email}")
        self.refresh_cloud_tasks()

    def refresh_cloud_tasks(self) -> None:
        if not self._cloud_signed_in():
            messagebox.showinfo("未登录", "请先登录云同步账号。")
            return
        self.cloud_status.configure(text="正在同步…")
        self.window.update_idletasks()
        try:
            self.tasks = self.cloud_client.list_tasks()  # type: ignore[union-attr]
        except CloudTaskError as error:
            self.cloud_status.configure(text="同步失败")
            messagebox.showerror("同步失败", str(error))
            return
        self.refresh_task_list()
        self._update_count()
        self.cloud_status.configure(
            text=f"已同步：{len(self.tasks)} 个任务"
        )

    def _cloud_signed_in(self) -> bool:
        return self.cloud_client is not None and self.cloud_client.signed_in

    def _persist_task(self, task: dict) -> None:
        if self._cloud_signed_in():
            try:
                updated = self.cloud_client.update_task(task)  # type: ignore[union-attr]
            except CloudTaskError as error:
                messagebox.showerror("云端保存失败", str(error))
                return
            task.update(updated)
            return
        self._save_tasks()

    def _check_reminders(self) -> None:
        now = datetime.now()
        changed = False
        for task in self.tasks:
            if (not task["reminder"] or task["completed"] or task["notified"]
                    or not task["date"] or not task["time"]):
                continue
            try:
                due = datetime.strptime(
                    f"{task['date']} {task['time']}", "%Y-%m-%d %H:%M"
                )
            except ValueError:
                continue
            if now >= due:
                task["notified"] = True
                changed = True
                self.window.bell()
                self.window.lift()
                messagebox.showinfo("任务提醒", f"该处理任务了：\n\n{task['title']}")
        if changed:
            if self._cloud_signed_in():
                for task in self.tasks:
                    if task.get("notified"):
                        try:
                            self.cloud_client.update_task(task)  # type: ignore[union-attr]
                        except CloudTaskError:
                            pass
            else:
                self._save_tasks()
        self.window.after(1_000, self._check_reminders)

    def _reset_form(self) -> None:
        for entry, placeholder in ((self.task_entry, "输入新任务…"),
                                   (self.date_entry, "日期：YYYY-MM-DD"),
                                   (self.time_entry, "时间：HH:MM")):
            entry.delete(0, "end")
            entry.insert(0, placeholder)
            entry.configure(fg=MUTED)
        self.editing_task_id = None
        self.reminder.set(False)
        self.add_button.configure(text="添加任务")

    def _update_count(self) -> None:
        self.count_label.configure(text=f"{len(self.task_list.get_children())} 个任务")

    @staticmethod
    def _add_placeholder(entry: tk.Entry, placeholder: str) -> None:
        def clear(_event: tk.Event) -> None:
            if entry.get() == placeholder:
                entry.delete(0, "end")
                entry.configure(fg=TEXT)

        def restore(_event: tk.Event) -> None:
            if not entry.get().strip():
                entry.insert(0, placeholder)
                entry.configure(fg=MUTED)

        entry.bind("<FocusIn>", clear)
        entry.bind("<FocusOut>", restore)

    @staticmethod
    def _field(parent: tk.Widget, placeholder: str, width: int) -> tk.Entry:
        field = tk.Entry(parent, width=width, bg=CARD, fg=MUTED, relief="flat",
                         highlightbackground=BORDER, highlightthickness=1,
                         font=("Microsoft YaHei UI", 10))
        field.insert(0, placeholder)
        TodoApp._add_placeholder(field, placeholder)
        field.pack(side="left", ipady=9, padx=(0, 12))
        return field


def main() -> None:
    window = tk.Tk()
    TodoApp(window)
    window.mainloop()


if __name__ == "__main__":
    main()
