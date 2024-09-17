import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { editUserInfo } from '../../api/UserApi';
@Entry
@Component
struct EditInfoPage {
  @State info:any={};
  aboutToAppear(){
    this.info=globalThis.info
  }
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text('修改个人信息')
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
              Text('昵称:').width(100)
              TextInput({text:this.info.nickName}).onChange((val)=>{
                this.info.nickName=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)
          ListItem(){
            Row(){
              Text('姓名:').width(100)
              TextInput({text:this.info.realName}).onChange((val)=>{
                this.info.realName=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)

          ListItem(){
            Row(){
              Text('手机号:').width(100)
              TextInput({text:this.info.phone}).onChange((val)=>{
                this.info.phone=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)

          ListItem(){
            Row(){
              Text('身份证:').width(100)
              TextInput({text:this.info.identityNum}).onChange((val)=>{
                this.info.identityNum=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)

          ListItem(){
            Row(){
              Text('地址:').width(100)
              TextInput({text:this.info.address}).onChange((val)=>{
                this.info.address=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)

        }.divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .borderRadius(10)
        .margin(5)
        .backgroundColor('#ffffff')
      }
      .width('100%')
      .layoutWeight(1)


      Row(){
        Button("保存").fontColor(Color.White).backgroundColor(Color.Red)
          .type(ButtonType.Normal)
          .width('100%')
          .borderRadius(20)
          .onClick(()=>{
            //验证格式
            let p=/^1[3-9][0-9]{9}$/;
            if(!p.test(this.info.phone)){
              promptAction.showToast({
                message: '手机号码输入有误!',
                duration: 2000,
              });
              return;
            }
            editUserInfo(this.info).then(rst=>{
              let code=JSON.parse(rst.result.toString()).code;
              if(code==20000){
                promptAction.showToast({
                  message: '修改成功!',
                  duration: 1000,
                });
                globalThis.info = this.info
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
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }

}