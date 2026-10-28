# 字体说明（playground/public/fonts）

本目录随产品源码一起交付，**不再从外网 CDN 加载任何字体**。

## 字重映射

`index.html` 里静态声明了 `@font-face`（注意：**不要**挪到 JS 运行时注入，见下）：

| CSS `font-weight` | 使用的字体文件 | 子集后大小 |
| --- | --- | --- |
| 300 | `HarmonyOS_Sans_SC_Light.woff2` | 796 KB |
| 400 / 500 | `MiSans-Regular.woff2` | 885 KB |
| 600 | `MiSans-Medium.woff2` | 893 KB |
| 700 / 800 / 900 | `MiSans-Demibold.woff2` | 898 KB |
| —（当前无引用） | `MiSans-Bold.woff2` | 910 KB |
| —（当前无引用） | `YSHaoShenTi.ttf` | 3.27 MB |

`body` 默认 `font-weight: 300`，因此**首屏必定加载** `HarmonyOS_Sans_SC_Light.woff2`。

## 为什么必须把 @font-face 放在 index.html

原先 `@font-face` 是在 `src/bootstrap.ts` 里用 `document.createElement('style')` 运行时注入的，
意味着字体请求要**等整个 JS bundle 下载并执行完**才发起，首屏被串行拖慢。
移到 `index.html` 的静态 `<style>` 后，浏览器解析 HTML 阶段就发现字体并行下载
（实测字体请求 start ≈ 85 ms，与 JS 同批）。

改动字体请同步修改 `index.html`，不要改回 `bootstrap.ts`。

## 子集化（Subsetting）

原始字体合计约 **29 MB**（单文件最大 9.27 MB），弱网下光下载字体就要几十秒。
现按「站点字符集 ∪ GB2312 一级汉字」子集化，合计降到 **4.4 MB**，单文件 0.8–0.9 MB。

字符集构成：
- 构建产物与源码中出现的全部字符（约 7,551 个，其中 CJK 2,171 个）
- ASCII 可见字符、常用中英文标点、常用符号
- GB2312 一级汉字 3,755 个（覆盖日常用字 99.7%，保证客户自己录入的中文不会掉字）

覆盖范围之外的生僻字会回落到系统字体（`PingFang SC` / `Microsoft YaHei` / `Noto Sans CJK SC`），
不会显示为方块。

重新生成（在 `ZhengXianApiFront` 根目录执行，需要 Python 与 `fonttools`、`brotli`）：

```bash
pip install fonttools brotli
python verify/fonts-subset.py       # 产出到 verify/fonts-subset/*.lvl1.woff2
python verify/fonts-install.py      # 同时导出可安装的 ttf，便于本机对照
# 再把 *.lvl1.woff2 覆盖回 playground/public/fonts/（去掉 .lvl1 后缀）
```

原始字体备份在 `verify/fonts-original/`，需要回归全量字形时从这里取。

## 缓存

字体的 URL 不含内容哈希，因此**必须**由 Web 服务器给出长缓存头，否则每次访问都要重下。
nginx 侧对 `/fonts/` 配置 `expires 1y; add_header Cache-Control "public, immutable";`。
