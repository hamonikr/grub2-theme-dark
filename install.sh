#!/bin/bash

# 패키지 및 디렉토리 정의
THEME_DIR="/usr/share/grub/themes/hamonikr-dark"
GRUB_CONFIG="/etc/default/grub"
GRUB_THEME="GRUB_THEME=\"$THEME_DIR/theme.txt\""

# 현재 배포판 확인
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "배포판을 감지할 수 없습니다."
    exit 1
fi

# 필요한 디렉토리 생성
sudo mkdir -p $THEME_DIR

# 테마 파일 복사
sudo cp -r usr/share/grub/themes/hamonikr-dark/* $THEME_DIR

# GRUB 설정 파일 수정 함수
update_grub_config() {
    if grep -q "^GRUB_THEME=" $GRUB_CONFIG; then
        sudo sed -i "s|^GRUB_THEME=.*|$GRUB_THEME|" $GRUB_CONFIG
    else
        echo "$GRUB_THEME" | sudo tee -a $GRUB_CONFIG
    fi
}

# 배포판에 따라 GRUB 업데이트
case $OS in
    arch|manjaro|opensuse-leap)
        update_grub_config
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo "Arch Linux/Manjaro에서 HamoniKR 테마가 성공적으로 설치되었습니다."
        ;;
    ubuntu|debian|hamonikr)
        update_grub_config
        sudo update-grub
        echo "Ubuntu/Debian에서 HamoniKR 테마가 성공적으로 설치되었습니다."
        ;;
    *)
        echo "이 스크립트는 Arch Linux, Manjaro, Ubuntu, Debian에서만 동작합니다."
        exit 1
        ;;
esac

