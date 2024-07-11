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

# GRUB 설정 파일 복구 함수
restore_grub_config() {
    if grep -q "^GRUB_THEME=" $GRUB_CONFIG; then
        sudo sed -i "/^GRUB_THEME=/d" $GRUB_CONFIG
    fi
}

# 배포판에 따라 GRUB 업데이트 및 테마 삭제
case $OS in
    arch|manjaro)
        restore_grub_config
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        sudo rm -rf $THEME_DIR
        echo "Arch Linux/Manjaro에서 HamoniKR 테마가 성공적으로 제거되었습니다."
        ;;
    ubuntu|debian|hamonikr)
        restore_grub_config
        sudo update-grub
        sudo rm -rf $THEME_DIR
        echo "Ubuntu/Debian에서 HamoniKR 테마가 성공적으로 제거되었습니다."
        ;;
    *)
        echo "이 스크립트는 Arch Linux, Manjaro, Ubuntu, Debian에서만 동작합니다."
        exit 1
        ;;
esac

