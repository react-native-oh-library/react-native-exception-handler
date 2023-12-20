import { ExceptionComponent } from 'rnoh-exception-handler';
import router from '@ohos.router';

interface RouterParam {
  errMsg: string
}

@Entry
@Component
struct ExceptionView {
  @State errMsg: string = ''

  aboutToAppear() {
    let params = router.getParams() as RouterParam
    this.errMsg = params.errMsg
    router.clear()
  }

  build() {
    Column() {
      ExceptionComponent({ errMsg: this.errMsg })
    }
    .width('100%')
    .height('100%')
  }
}