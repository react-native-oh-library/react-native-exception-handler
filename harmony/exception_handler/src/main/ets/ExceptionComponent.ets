/*
 * MIT License
 *
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import common from '@ohos.app.ability.common';
import appRecovery from '@ohos.app.ability.appRecovery';

@Component
export struct ExceptionComponent {
  private errMsg: string = "";
  @State message: string = 'SHOW DETAILS'
  @State visible: boolean = false

  @Builder ButtonBuilder(text: string, click: () => void) {
    Button(text, { type: ButtonType.Normal, stateEffect: true })
      .fontColor('#000')
      .fontWeight(FontWeight.Bolder)
      .layoutWeight(1)
      .borderRadius(8)
      .backgroundColor('#CFCFCF')
      .onClick(click)
  }

  relaunch() {
    console.info(`relaunch`)
    appRecovery.restartApp()
  }

  quit() {
    console.info(`quit`)
    let context = getContext(this) as common.UIAbilityContext; // UIAbilityContext
    context.terminateSelf((error) => {
      if (error.code) {
        // 处理业务逻辑错误
        console.error(`terminateSelf failed, error.code: ${error.code}, error.message: ${error.message}`);
        return;
      }

      // 执行正常业务
      console.log('terminateSelf succeed');
    });
  }

  build() {
    Column() {
      Text('Critical Error Occurred !')
        .fontSize(20)
        .fontWeight(FontWeight.Bolder)
        .padding({ top: 50, bottom: 20 })
      Image($r("app.media.ic_public_error"))
        .width(50)
        .height(50)
      Text('This is embarrassing. We sincerely apologize for this.')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .padding({ left: 40, top: 20, right: 40 })
      Row({ space: 10 }) {
        this.ButtonBuilder('RELAUNCH', this.relaunch)
        this.ButtonBuilder('QUIT', this.quit)
      }.padding({ left: 20, top: 20, right: 20 })

      Button(this.message, { stateEffect: false })
        .fontSize(10)
        .fontColor('#000')
        .fontWeight(FontWeight.Bolder)
        .backgroundColor('#FFF')
        .onClick(() => {
          this.message = this.visible ? 'SHOW DETAILS' : 'HIDE DETAILS'
          this.visible = !this.visible
        })
      Text(this.errMsg)
        .backgroundColor('#ECECEC')
        .visibility(this.visible ? Visibility.Visible : Visibility.Hidden)
        .width(330)
        .height(500)
    }
    .width('100%')
    .height('100%')
  }
}