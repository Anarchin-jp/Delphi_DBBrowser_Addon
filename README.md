# Delphi DB Browser Add-on

Delphi IDE에서 직접 데이터베이스를 탐색하고 쿼리를 실행할 수 있는 유용한 애드온 도구입니다.

[Korean/한국어](./README.md) | [Japanese/日本語](./README_JA.md)

## 🚀 주요 기능

- **다양한 DB 지원**: SQLite, MySQL, MSSQL 접속 지원
- **스마트 쿼리 실행**: 
  - `Shift+Enter` 단축키로 즉시 실행
  - 에디터에서 블록 지정(하이라이트)된 부분만 선택적으로 실행 가능
- **개체 탐색기**: Table과 View를 트리 구조로 시각화하여 제공
- **자동 연결**: 프로젝트 디렉토리의 `dbbrowser.ini` 파일을 통한 세션 자동 복구
- **SSL 지원**: MySQL 접속 시 `.pem` 인증서 파일을 이용한 보안 접속 지원
- **간편한 입력**: 트리뷰 테이블명 더블 클릭 시 커서 위치에 테이블명 자동 삽입 (Auto 모드 해제 시)

## 🛠 설치 방법

1. 소스 코드를 다운로드합니다.
2. Delphi IDE에서 `DBBrowserPackage.dproj` 파일을 엽니다.
3. **Project Manager**에서 `DBBrowserPackage.bpl`을 마우스 오른쪽 버튼으로 클릭합니다.
4. **Build**를 먼저 수행한 후, **Install**을 클릭합니다.
5. 설치가 완료되면 IDE 상단 메뉴 또는 지정된 View 메뉴에서 `DB Browser`를 실행할 수 있습니다.

## 📋 사용 환경
- **Delphi 버전**: Delphi 10 이상 권장 Delphi Xe 이상버전 가능
- **OS**: Windows

## 👤 만든이
- anarchin.moon@gmail.com

## 👤 소프트웨어 개발및 모듈개발 의뢰
- 영상처리
- TTS, STT 음성처리
- IOT 제어관련
- 기타 델파이 개발 관련

## 📄 버전 정보
- **Current Version**: v0.8

## ⚖ 라이센스
이 프로젝트는 **MIT License**를 따릅니다. 상세 내용은 아래와 같습니다.

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
