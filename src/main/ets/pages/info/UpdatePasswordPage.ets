import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { updatePassword } from '../../api/UserApi';

@Entry
@Component
struct UpdatePasswordPage {
  @State oldPassword:string='';
  @State newPassword:string='';
  @State reNewPassword:string=''
  aboutToAppear(){

  }
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text('修改密码')
          .width('100%')
          .height(60)
          .fontSize(20)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor(Color.Grey)
        Image($r('app.media.iv_back_selected')).width(40).height(40)
          .onClick(() => {
            router.back();
          }).margin({ left: 10 })
      }.height(60).width('100%').margin({ top: 10 })

      Column() {
        //基本信息
        List() {
          ListItem(){
            Row(){
              Text('原始密码:').width(100)
              TextInput().onChange((val)=>{
                this.oldPassword=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)
          ListItem(){
            Row(){
              Text('新密码:').width(100)
              TextInput().onChange((val)=>{
                this.newPassword=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)
          ListItem(){
            Row(){
              Text('确认新密码:').width(100)
              TextInput().onChange((val)=>{
                this.reNewPassword=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)
        }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .borderRadius(10)
        .margin(5)
        .backgroundColor('#ffffff')
      }
      .width('100%')
      //.margin({top:70})
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)

      Row(){
        Button("保存").fontColor(Color.White).backgroundColor(Color.Red)
          .type(ButtonType.Normal)
          .width('100%')
          .borderRadius(20)
          .onClick(()=>{
            //验证格式
            updatePassword(this.newPassword,this.oldPassword)
              .then(rst=>{
                let code=JSON.parse(rst.result.toString()).code;
                if(code==20000){
                  promptAction.showToast({
                    message: '修改成功!下次请使用新密码登录!',
                    duration: 1000,
                  });
                  setTimeout(()=>{
                    router.back();
                  },1000)
                }else{
                  promptAction.showToast({
                    message: '修改失败!',
                    duration: 2000,
                  });
                }
              })
          })
      }.alignItems(VerticalAlign.Bottom).padding(10).backgroundColor('#ffffff')
      .width('100%')
    }
    .height('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }

}