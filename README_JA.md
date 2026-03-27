# Delphi DB Browser Add-on

Delphi IDEから直接データベースを探索し、クエリを実行できる便利なアドオンツールです。

[Korean/한국어](./README.md) | [Japanese/日本語](./README_JA.md)

## 🚀 主な機能

- **多彩なDBサポート**: SQLite, MySQL, MSSQL への接続をサポート
- **スマートなクエリ実行**:
  - `Shift+Enter` ショートカットで即時実行
  - 에디터でブロック選択（ハイライト）した部分のみを選択的に実行可能
- **オブジェクトブラウザ**: Table と View をツリー構造で視覚化して提供
- **自動接続**: プロジェクトディレクトリの `dbbrowser.ini` ファイルを通じてセッションを自動復元
- **SSLサポート**: MySQL 接続時に `.pem` 証明書ファイルを利用したセキュアな接続をサポート
- **便利な入力**: ツリービューのテーブル名をダブルクリックすると、カーソル位置にテーブル名を自動挿入 (Autoモード解除時)

## 🛠 インストール方法

1. ソースコードをダウンロードします。
2. Delphi IDEで `DBBrowserPackage.dproj` ファイルを開きます。
3. **Project Manager** で `DBBrowserPackage.bpl` を右クリックします。
4. **Build** を先に実行した後、**Install** をクリックします。
5. インストールが完了すると、IDEの上部メニューまたは指定された View メニューから `DB Browser` を実行できます。

## 📋 動作環境

- **Delphi バージョン**: Delphi 12 以上推奨
- **OS**: Windows

## 👤 作成者

- <anarchin.moon@gmail.com>

## 👤 ソフトウェア開発およびモ듈開発のご依頼

- 画像処理
- TTS, STT 音声処理
- IOT 制御関連
- その他 Delphi 開発 관련

## 📄 バージョン情報

- **Current Version**: v0.8

## ⚖ ライセンス

このプロジェクトは **MIT License** に従います。詳細は以下の通りです。

```text
MIT License

Copyright (c) 2026 USER

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
