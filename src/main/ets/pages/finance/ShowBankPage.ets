import router from '@ohos.router'
import http from '@ohos.net.http';
import { baseUrl } from '../../api/BaseData';

@Entry
@Component
struct ShowBankPage {
  scroller: Scroller = new Scroller()
  @State banks: any = [];
  @State bankMap:any=[];
  getShowBank() {
    let url = baseUrl+"/finance/selectbank";
    let httpRequest = http.createHttp();
    httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        Authorization: globalThis.token
      }
    }, (err, data) => {
      if (!err) {
        this.banks = [];
        this.bankMap=new Array();
        let imageDataArray = JSON.parse(data.result.toString()).data;
        for (let b of imageDataArray) {
          this.banks.push(b);
          this.bankMap[b.bankId]=b;
        }
        //把银行信息存放到公共区域
        globalThis.bankMap=this.bankMap;
      } else {
        httpRequest.destroy();
      }
    })
  }

  aboutToAppear() {
    this.getShowBank()
  }

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text('银行信息列表')
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
        //信息列表
        Scroll(this.scroller){
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }){
            ForEach(this.banks,(item,index)=>{
              Row(){
                Image('bank_icon/bank'+item.bankId+".jpg")
                  .width(188).height(188).objectFit(ImageFit.Fill)
                  .borderRadius(10)
              }.width('47%')
              .height(188)
              .borderRadius(5)
              .borderWidth(1)
              .borderColor(Color.Gray)
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .shadow({ radius: 5, color: Color.Gray, offsetX: 5, offsetY: 5 })
              .margin(5)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/finance/BankInfoPage',
                  params: { 'info': item }
                })
              })

            },item=>item.bankId)
          }.padding({bottom:20}).margin({bottom:80})
        }.width('100%').height('100%')
        .scrollable(ScrollDirection.Vertical)

      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}