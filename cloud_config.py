"""读取 Simple Todo 的云端配置。"""

import os
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class CloudConfig:
    url: str
    publishable_key: str

    @property
    def configured(self) -> bool:
        return bool(self.url and self.publishable_key)


def load_cloud_config() -> CloudConfig:
    """从环境变量读取公开的 Supabase 客户端配置。"""
    file_config = _load_env_file()
    return CloudConfig(
        url=(os.getenv("SUPABASE_URL", "").strip()
             or file_config.get("SUPABASE_URL", "")),
        publishable_key=(
            os.getenv("SUPABASE_PUBLISHABLE_KEY", "").strip()
            or os.getenv("SUPABASE_ANON_KEY", "").strip()
            or file_config.get("SUPABASE_PUBLISHABLE_KEY", "")
            or file_config.get("SUPABASE_ANON_KEY", "")
        ),
    )


def _load_env_file() -> dict[str, str]:
    """读取程序旁边或项目目录里的 .env 文件。"""
    if getattr(sys, "frozen", False):
        env_file = Path(sys.executable).with_name(".env")
    else:
        env_file = Path(__file__).with_name(".env")

    if not env_file.exists():
        return {}

    values: dict[str, str] = {}
    for line in env_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values
