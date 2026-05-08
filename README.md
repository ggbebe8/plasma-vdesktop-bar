# Plasma Virtual Desktop Bar

A clean, intuitive, and highly functional Virtual Desktop & Task Manager widget for **KDE Plasma 6**.

![Plasma 6](https://img.shields.io/badge/KDE_Plasma-6.0%2B-blue?logo=kde&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Virtual Desktop Bar**는 KDE Plasma 6 환경에서 가상 데스크톱과 실행 중인 프로그램들을 한눈에 파악하고 제어할 수 있게 해주는 커스텀 패널 위젯입니다. 각 가상 데스크톱 번호와 해당 데스크톱에서 실행 중인 앱 아이콘을 묶어서 표시하며, 직관적인 창 전환 경험을 제공합니다.

## ✨ 주요 기능 (Features)

* **직관적인 UI:** 현재 사용 중인 가상 데스크톱을 하이라이트하여 보여줍니다.
* **데스크톱별 작업 표시:** 각 가상 데스크톱에 어떤 프로그램들이 띄워져 있는지 아이콘으로 표시합니다.
* **원클릭 창 활성화 (Smart Focus):** 다른 데스크톱에 있는 프로그램 아이콘을 클릭하면, 시스템이 **자동으로 해당 가상 데스크톱으로 화면을 전환한 뒤 창을 최상단으로 끌어올립니다.**
* **시각적 피드백:** 마우스 호버(Hover) 효과와 현재 활성화된 창(Active Window)에 대한 테두리 강조 효과를 제공합니다.
* **네이티브 최적화:** KWin 및 Plasma 6의 네이티브 `TaskManager` API를 사용하여 빠르고 충돌 없이 작동합니다.

## 🛠 요구 사항 (Requirements)

* KDE Plasma 6.0 이상
* 가상 데스크톱 기능 활성화 필요

## 🚀 설치 방법 (Installation)

가장 편한 방법을 선택하여 설치할 수 있습니다.

### 방법 1: `.plasmoid` 파일로 설치

1. 이 저장소의 [Releases] 페이지에서 최신 `com.gnoeyps.vdbar.plasmoid` 파일을 다운로드합니다.
2. 터미널을 열고 아래 명령어를 입력합니다:
```bash
   kpackagetool6 -t Plasma/Applet -i com.gnoeyps.vdbar.plasmoid
    # Plasma 쉘을 재시작하여 위젯을 시스템에 적용합니다:
    plasmashell --replace &
```
 3. 바탕화면 패널에서 우클릭 -> [위젯 추가] -> Virtual Desktop Bar를 검색하여 패널에 추가합니다.

### 방법 2: Git 소스 코드로 직접 설치

터미널에서 이 저장소를 클론하고 직접 빌드(설치)할 수 있습니다.
```Bash

git clone [https://github.com/ggbebe8/plasma-vdesktop-bar.git](https://github.com/ggbebe8/plasma-vdesktop-bar.git)
cd plasma-vdesktop-bar
kpackagetool6 -t Plasma/Applet -i .
plasmashell --replace &
```
🔄 업데이트 방법 (Updating)

새로운 버전이 나왔거나 코드를 수정한 경우, -i (install) 대신 -u (upgrade) 옵션을 사용하세요.
```Bash
kpackagetool6 -t Plasma/Applet -u .
plasmashell --replace &
```
