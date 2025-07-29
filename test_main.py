# test_main.py

import subprocess
import httpx
from main import ping_host, get_public_ip
from main import detect_gateway_info
import psutil

def test_ping_host_success(monkeypatch):
    def fake_run(*args, **kwargs):
        class Result:
            returncode = 0
        return Result()
    monkeypatch.setattr(subprocess, "run", fake_run)
    assert ping_host("1.1.1.1") is True


def test_ping_host_failure(monkeypatch):
    def fake_run(*args, **kwargs):
        class Result:
            returncode = 1
        return Result()
    monkeypatch.setattr(subprocess, "run", fake_run)
    assert ping_host("1.1.1.1") is False


def test_get_public_ip_success(monkeypatch):
    def fake_get(*args, **kwargs):
        class Response:
            def raise_for_status(self): pass
            text = "123.123.123.123"
        return Response()
    monkeypatch.setattr(httpx, "get", fake_get)
    assert get_public_ip() == "123.123.123.123"


def test_get_public_ip_failure(monkeypatch):
    def fake_get(*args, **kwargs):
        raise httpx.HTTPError("Service unreachable")
    monkeypatch.setattr(httpx, "get", fake_get)
    assert get_public_ip() is None


def test_detect_gateway_info(monkeypatch):
    class FakeAddress:
        family = type("AF", (), {"name": "AF_INET"})
        address = "192.168.1.51"
        netmask = "255.255.255.0"

    class FakeStats:
        isup = True

    def fake_net_if_stats():
        return {"wifi0": FakeStats()}

    def fake_net_if_addrs():
        return {"wifi0": [FakeAddress()]}

    monkeypatch.setattr(psutil, "net_if_stats", fake_net_if_stats)
    monkeypatch.setattr(psutil, "net_if_addrs", fake_net_if_addrs)

    result = detect_gateway_info()
    assert result == ("192.168.1.1", "192.168.1.0/24", "192.168.1.51")
