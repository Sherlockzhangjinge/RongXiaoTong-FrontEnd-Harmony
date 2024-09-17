import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { addQuestion } from '../../api/ExpertApi';
@Entry
@Component
struct ExpertQuestionPage {
  @State info:any={};

  aboutToAppear(){
    let name=router.getParams()["name"];
    this.info.expertName=name;
  }
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text('提问问题')
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
              Text('标题:').width(100)
              TextInput().onChange((val)=>{
                this.info.title=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)
          ListItem(){
            Row(){
              Text('内容:').width(100)
              TextInput().onChange((val)=>{
                this.info.question=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)

          ListItem(){
            Row(){
              Text('农作物名称:').width(100)
              TextInput().onChange((val)=>{
                this.info.plantName=val
              }).borderWidth(0).backgroundColor(Color.Transparent)
            }
          }.padding({left:20,right:20}).height(60)

          ListItem(){
            Row(){
              Text('手机号码:').width(100)
              TextInput().onChange((val)=>{
                this.info.phone=val
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


      Row(){
        Button("提交").fontColor(Color.White).backgroundColor(Color.Red)
          .type(ButtonType.Normal)
          .width('100%')
          .borderRadius(20)
          .onClick(()=>{

            addQuestion(this.info).then(data=>{
              let code=JSON.parse(data.result.toString()).code;
              if(code==20000){
                promptAction.showToast({
                  message: '提交成功!',
                  duration: 1000,
                });
                setTimeout(()=>{
                  router.back();
                },1000)
              }else{
                promptAction.showToast({
                  message: '提交失败!',
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