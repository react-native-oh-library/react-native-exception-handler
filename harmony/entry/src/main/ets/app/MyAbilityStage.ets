import AbilityStage from "@ohos.app.ability.AbilityStage";
import appRecovery from "@ohos.app.ability.appRecovery";
import Want from "@ohos.app.ability.Want";

export default class MyAbilityStage extends AbilityStage {
  onCreate() {
    appRecovery.enableAppRecovery();
    let want: Want = {
      bundleName: this.context.applicationInfo.name,
      abilityName: this.context.currentHapModuleInfo.mainElementName,
    };
    appRecovery.setRestartWant(want);
  }
}