"""读取 Simple Todo 的云端配置。"""

import os
from dataclasses import dataclass


@dataclass(frozen=True)
class CloudConfig:
    url: str
    publishable_key: str

    @property
    def configured(self) -> bool:
        return bool(self.url and self.publishable_key)


def load_cloud_config() -> CloudConfig:
    """从环境变量读取公开的 Supabase 客户端配置。"""
    return CloudConfig(
        url=os.getenv("SUPABASE_URL", "").strip(),
        publishable_key=os.getenv("SUPABASE_PUBLISHABLE_KEY", "").strip(),
    )
