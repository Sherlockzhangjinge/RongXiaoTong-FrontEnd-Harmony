/**
 * 智能匹配页面
 */
import router from '@ohos.router'
import { getMyReserve } from '../../api/ExpertApi';

@Preview
@Entry
@Component
struct MyReservePage {
  @State isShow:boolean=false
  @State wenDaData: any = [];
  @State wenDa:any={}
  @State isEdit:boolean =false;
  getAllReserve(){
    getMyReserve().then(rst=>{
      let items=JSON.parse(rst.result.toString()).data;
      for(let item of items){
        this.wenDaData.push(item);
      }
    })
  }
  aboutToAppear() {
    this.getAllReserve()
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Start }) {
        Text('预约信息')
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

      List() {
        ForEach(this.wenDaData, (item, index) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.plantName).margin(3).fontWeight(FontWeight.Bolder)
                Text("专家名称:" + item.expertName).margin(3)
                Text("作物条件:" + item.plantCondition).margin(3)
                Text("土壤条件:" + item.soilCondition)
                  .margin(3)
                Text("面积:" + item.area+ "亩").margin(3)
                if (item.status==0) {
                  Text('未处理').backgroundColor('#fef0f0').fontColor('#f56c6c').margin(3)
                }else{
                  Text('已处理').backgroundColor('#409eff').fontColor('#f5f7fa').margin(3)
                }
              }.alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              Row(){
                Text("详情").margin({right:10}).onClick(()=>{
                  router.pushUrl({url:'pages/info/MyReserveInfoPage',params:{info:JSON.stringify(item)}})
                })
              }
            }
            .borderWidth(1)
            .borderRadius(10)
            .borderColor(Color.Grey)
            .margin(10)
            .padding(10)
            .width('95%')
          }
        }, (item, index) => item + index)
      }.margin({ top: 60, bottom: 60 })

    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}