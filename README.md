# hokeshi-pkgs

deepin 风格应用的 Linux 原生版本 RPM 与 Arch 包仓库。由 GitHub Actions 将上游提供的 .deb（amd64）自动转换为 Fedora / RHEL 系可用的 .rpm 与 Arch Linux 可用的 .pkg.tar.zst（x86_64），构建完成后自动发布到 [Releases](https://github.com/WenYin-Community/hokeshi-pkgs/releases)。

> 这些软件包为 Linux 原生版本（多为 Electron / Web 封装），并非 Wine 运行 Windows 程序，仅借用了 deepin 应用包格式（`/opt/apps` 目录结构）。

> 觉得好用请给个star吧~！若有问题或建议，请开issue或来Q群634133484

## 安装

从下方表格或 [Releases](https://github.com/WenYin-Community/hokeshi-pkgs/releases) 下载对应软件包。

**RPM（Fedora / RHEL 系）**

```bash
sudo dnf install ./包名.rpm
```

**Arch（Arch Linux / Manjaro 等）**

```bash
sudo pacman -U 包名.pkg.tar.zst
```

所有包均为 x86_64 架构（由上游 amd64 deb 转换）。

## 软件包

| 软件名 | 包名 | 版本号 | 支持架构 | RPM | Arch |
| --- | --- | --- | --- | --- | --- |
| 微信多重影 | otohime.wechat.kages | 4.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.wechat.kages-4.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/otohime.wechat.kages-4.0-1-x86_64.pkg.tar.zst "点击") |
| 希沃白板5 for Linux | com.seewo.easinote5 | 5.2.2.4.13964-fix3 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.seewo.easinote5-5.2.2.4.13964_fix3-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/com.seewo.easinote5-5.2.2.4.13964_fix3-1-x86_64.pkg.tar.zst "点击") |
| 抖音 for linux | com.douyin.otohime | 8.3.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.douyin.otohime-8.3.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/com.douyin.otohime-8.3.0-1-x86_64.pkg.tar.zst "点击") |
| 网易云音乐 for Linux | netease.cloud.music.otohime | 3.1.34 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/netease.cloud.music.otohime-3.1.34-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/netease.cloud.music.otohime-3.1.34-1-x86_64.pkg.tar.zst "点击") |
| 响七菜切图NG | otohime.hibikinana.cutemoji | 7.1 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.hibikinana.cutemoji-7.1-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/otohime.hibikinana.cutemoji-7.1-1-x86_64.pkg.tar.zst "点击") |
| 小丑牌 | balatro-linux | 1.1.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/balatro-linux-1.1.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/balatro-linux-1.1.0-1-x86_64.pkg.tar.zst "点击") |
| 千问客户端 for linux | com.qianwen.otohime | 3.7.5.145 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.qianwen.otohime-3.7.5.145-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/com.qianwen.otohime-3.7.5.145-1-x86_64.pkg.tar.zst "点击") |
| 千问客户端国际版 for linux | ai.qwen.otohime | 1.0.3 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/ai.qwen.otohime-1.0.3-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/ai.qwen.otohime-1.0.3-1-x86_64.pkg.tar.zst "点击") |
| Deepin-Wine转区工具 | otohime.deepin-wine.localemulator | 3.6 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.deepin-wine.localemulator-3.6-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/otohime.deepin-wine.localemulator-3.6-1-x86_64.pkg.tar.zst "点击") |
| 採图标 | otohime.cai.ico | 22.04.26 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.cai.ico-22.04.26-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/otohime.cai.ico-22.04.26-1-x86_64.pkg.tar.zst "点击") |
| 字符映射表NG | otohime.charmap | 5.2.3670.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.charmap-5.2.3670.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/otohime.charmap-5.2.3670.0-1-x86_64.pkg.tar.zst "点击") |
| 爱奇艺 for linux | com.iqiyi.otohime | 14.4.5.9968 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.iqiyi.otohime-14.4.5.9968-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/com.iqiyi.otohime-14.4.5.9968-1-x86_64.pkg.tar.zst "点击") |
| 腾讯视频Linux版 Re:Birth | tenvideo-universal | 11.178.5334.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/tenvideo-universal-11.178.5334.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/tenvideo-universal-11.178.5334.0-1-x86_64.pkg.tar.zst "点击") |
| PDF试卷切题工具 | pdf-to-ppt-tool | 2.5 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/pdf-to-ppt-tool-2.5-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/pdf-to-ppt-tool-2.5-1-x86_64.pkg.tar.zst "点击") |
| 国家中小学智慧教育平台 | zxxedu | 1.3.11 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/zxxedu-1.3.11-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/zxxedu-1.3.11-1-x86_64.pkg.tar.zst "点击") |
| QQ音乐 | com.qq.music | 1.1.8.3 | x86_64 | 暂无 | 暂无 |
| 蓝奏云盘 | lanzou.disk.otohime | 4.0.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/lanzou.disk.otohime-4.0.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/lanzou.disk.otohime-4.0.0-1-x86_64.pkg.tar.zst "点击") |
| 语雀 | com.yuque.otohime | 4.2.1.1333 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.yuque.otohime-4.2.1.1333-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/com.yuque.otohime-4.2.1.1333-1-x86_64.pkg.tar.zst "点击") |
| MoeKoe Music | moekoemusic | 1.6.8 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/moekoemusic-1.6.8-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/moekoemusic-1.6.8-1-x86_64.pkg.tar.zst "点击") |
| 腾讯元宝 | com.tencent.yuanbao.otohime | 2.79 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.tencent.yuanbao.otohime-2.79-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/com.tencent.yuanbao.otohime-2.79-1-x86_64.pkg.tar.zst "点击") |
| 小丸工具箱粉丝重制版 for Linux | maruko.toolbox.rewrite | 1.1.2 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/maruko.toolbox.rewrite-1.1.2-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/maruko.toolbox.rewrite-1.1.2-1-x86_64.pkg.tar.zst "点击") |
| 观潮台 | dowjones.guanchaotai.otohime | 2.0.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/dowjones.guanchaotai.otohime-2.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/dowjones.guanchaotai.otohime-2.0-1-x86_64.pkg.tar.zst "点击") |
| lossless-cut无损剪辑 | github.mifi.losslesscut | 3.69.0 | x86_64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/github.mifi.losslesscut-3.69.0-1.x86_64.rpm "点击") | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/arch-20260812-080220/github.mifi.losslesscut-3.69.0-1-x86_64.pkg.tar.zst "点击") |

## 致谢

本仓库的软件包均基于以下上游项目提供的 .deb 自动转换而来，感谢上游作者的辛勤维护：

- [kota-rina3/hokeshi](https://github.com/kota-rina3/hokeshi)：deepin-wine 风格应用的主仓库
- [kota-rina3/dwle](https://github.com/kota-rina3/dwle)：Deepin-Wine 转区工具
- [kota-rina3/charmap-ng](https://github.com/kota-rina3/charmap-ng)：字符映射表
- [kota-rina3/MarukoToolbox-Rewrite-Linux](https://github.com/kota-rina3/MarukoToolbox-Rewrite-Linux)：小丸工具箱粉丝重制版
