/**
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
import { TurboModule, TurboModuleContext } from "@rnoh/react-native-openharmony/ts";
import { ComponentContent, PromptAction, promptAction, window } from '@kit.ArkUI';
import { common, errorManager } from '@kit.AbilityKit';

let observerIds: number[] = [];
interface RealViewPointType {
  'error': string;
};

@Builder
function buildErrorDialog(errorMsg: ESObject) {
  Column() {
    Text('Unexpected error occured')
      .fontSize(24)
      .fontStyle(FontStyle.Normal)
      .baselineOffset(-40)
      .textAlign(TextAlign.Center)
      .width("80%")
    Text('Appologies..The app will close now   Please restart the app')
      .baselineOffset(-5)
      .textAlign(TextAlign.Center)
      .width("80%")
    Text(errorMsg.error)
      .textAlign(TextAlign.Center)
      .baselineOffset(-5)
      .width("80%")
  }.backgroundColor('#ffffff').width("80%").height("80%").borderRadius(10)
}

export class ExceptionHandlerTurboModule extends TurboModule {
  constructor(ctx: TurboModuleContext) {
    super(ctx)
  }

  setHandlerForNativeException(handler: (errMsg: string) => void, executeDefaultHandler?: boolean): void {
    if (!executeDefaultHandler) {
      if (observerIds.length > 0) {
        observerIds.forEach(id => {
          errorManager.off('error', id);
        })
      }
    }

    const uiAbilityContext: common.UIAbilityContext = this.ctx.uiAbilityContext
    let observer: errorManager.ErrorObserver = {
      onUnhandledException(errorMsg) {
        handler(errorMsg)
        console.error('onUnhandledException, errorMsg: ', errorMsg);
        const realViewPoint: RealViewPointType = {
          error:errorMsg
        }
        window.getLastWindow(uiAbilityContext)
          .then((value) => {
            const uiContext: UIContext = value.getUIContext();
            const promptAction: PromptAction = uiContext?.getPromptAction();
            const contentNode: ComponentContent<RealViewPointType> =
              new ComponentContent(uiContext!, wrapBuilder(buildErrorDialog), realViewPoint);
            const options: promptAction.BaseDialogOptions = {
              autoCancel: false
            }
            try {
              promptAction?.openCustomDialog(contentNode, options);
            } catch (error) {
              console.error(`eroor`);
            }
          })
      }
    };
    try {
      const observerId: number = errorManager.on('error', observer);
      observerIds.push(observerId);
    } catch (error) {
      console.error(`registerErrorObserver failed, error.code: ${error.code}, error.message: ${error.message}`);
    }
  }
}




