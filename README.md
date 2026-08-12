# hokeshi-pkgs

deepin-wine 风格应用的 RPM 包仓库。由 GitHub Actions 将上游提供的 .deb（amd64）自动转换为 Fedora / RHEL 系可用的 .rpm（x86_64），构建完成后自动发布到 [Releases](https://github.com/WenYin-Community/hokeshi-pkgs/releases)。

> 觉得好用请给个star吧~！若有问题或建议，请开issue或来Q群634133484

## 安装

从下方表格或 [Releases](https://github.com/WenYin-Community/hokeshi-pkgs/releases) 下载对应 .rpm 后：

```bash
sudo dnf install ./包名.rpm
```

所有 rpm 均为 x86_64 架构（由上游 amd64 deb 转换，表中架构列为上游 deb 的支持范围）。

## 软件包

| 软件名 | 包名 | 版本号 | 支持架构 | 地址 |
| --- | --- | --- | --- | --- |
| 微信多重影 | otohime.wechat.kages | 4.0 | amd64、arm64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.wechat.kages-4.0-1.x86_64.rpm "点击") |
| 希沃白板5 for Linux | com.seewo.easinote5 | 5.2.2.4.13964-fix3 | amd64、arm64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.seewo.easinote5-5.2.2.4.13964_fix3-1.x86_64.rpm "点击") |
| 抖音 for linux | com.douyin.otohime | 8.3.0 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.douyin.otohime-8.3.0-1.x86_64.rpm "点击") |
| 网易云音乐 for Linux | netease.cloud.music.otohime | 3.1.34 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/netease.cloud.music.otohime-3.1.34-1.x86_64.rpm "点击") |
| 响七菜切图NG | otohime.hibikinana.cutemoji | 7.1 | amd64、arm64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.hibikinana.cutemoji-7.1-1.x86_64.rpm "点击") |
| 小丑牌 | balatro-linux | 1.1.0 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/balatro-linux-1.1.0-1.x86_64.rpm "点击") |
| 千问客户端 for linux | com.qianwen.otohime | 3.7.5.145 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.qianwen.otohime-3.7.5.145-1.x86_64.rpm "点击") |
| 千问客户端国际版 for linux | ai.qwen.otohime | 1.0.3 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/ai.qwen.otohime-1.0.3-1.x86_64.rpm "点击") |
| Deepin-Wine转区工具 | otohime.deepin-wine.localemulator | 3.6 | amd64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.deepin-wine.localemulator-3.6-1.x86_64.rpm "点击") |
| 採图标 | otohime.cai.ico | 22.04.26 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.cai.ico-22.04.26-1.x86_64.rpm "点击") |
| 字符映射表NG | otohime.charmap | 5.2.3670.0 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/otohime.charmap-5.2.3670.0-1.x86_64.rpm "点击") |
| 爱奇艺 for linux | com.iqiyi.otohime | 14.4.5.9968 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.iqiyi.otohime-14.4.5.9968-1.x86_64.rpm "点击") |
| 腾讯视频Linux版 Re:Birth | tenvideo-universal | 11.178.5334.0 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/tenvideo-universal-11.178.5334.0-1.x86_64.rpm "点击") |
| PDF试卷切题工具 | pdf-to-ppt-tool | 2.5 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/pdf-to-ppt-tool-2.5-1.x86_64.rpm "点击") |
| 国家中小学智慧教育平台 | zxxedu | 1.3.11 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/zxxedu-1.3.11-1.x86_64.rpm "点击") |
| QQ音乐 | com.qq.music | 1.1.8.3 | amd64、arm64、loong64 | 暂无 |
| 蓝奏云盘 | lanzou.disk.otohime | 4.0.0 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/lanzou.disk.otohime-4.0.0-1.x86_64.rpm "点击") |
| 语雀 | com.yuque.otohime | 4.2.1.1333 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.yuque.otohime-4.2.1.1333-1.x86_64.rpm "点击") |
| MoeKoe Music | moekoemusic | 1.6.8 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/moekoemusic-1.6.8-1.x86_64.rpm "点击") |
| 腾讯元宝 | com.tencent.yuanbao.otohime | 2.79 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/com.tencent.yuanbao.otohime-2.79-1.x86_64.rpm "点击") |
| 小丸工具箱粉丝重制版 for Linux | maruko.toolbox.rewrite | 1.1.2 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/maruko.toolbox.rewrite-1.1.2-1.x86_64.rpm "点击") |
| 观潮台 | dowjones.guanchaotai.otohime | 2.0.0 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/dowjones.guanchaotai.otohime-2.0-1.x86_64.rpm "点击") |
| lossless-cut无损剪辑 | github.mifi.losslesscut | 3.69.0 | amd64、arm64、loong64 | [点击](https://github.com/WenYin-Community/hokeshi-pkgs/releases/download/rpm-20260812-052901/github.mifi.losslesscut-3.69.0-1.x86_64.rpm "点击") |

## 致谢

本仓库的软件包均基于以下上游项目提供的 .deb 自动转换而来，感谢上游作者的辛勤维护：

- [kota-rina3/hokeshi](https://github.com/kota-rina3/hokeshi)：deepin-wine 风格应用的主仓库
- [kota-rina3/dwle](https://github.com/kota-rina3/dwle)：Deepin-Wine 转区工具
- [kota-rina3/charmap-ng](https://github.com/kota-rina3/charmap-ng)：字符映射表
- [kota-rina3/MarukoToolbox-Rewrite-Linux](https://github.com/kota-rina3/MarukoToolbox-Rewrite-Linux)：小丸工具箱粉丝重制版

