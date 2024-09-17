import http from '@ohos.net.http'
import router from '@ohos.router';
import { getAddressList } from '../api/AddressApi';
@Entry
@Component
struct ShowAddressPage {

  @State allAddresses:Array<any>=[]
  getAllAddresses(){
    getAddressList().then((res)=>{
      let items=JSON.parse(res.result.toString()).data;
      for(let item of items){
        let address={
          addressDetail:item.addressDetail,
          consignee:item.consignee,
          id:item.id,
          isDefault:item.isDefault,
          ownName:item.ownName,
          phone:item.phone
        }
        this.allAddresses.push(address)
      }
    })

  }
  showTel(tel:string){
    let str=tel.substring(0,3)+"****"+tel.substring(7);
    return str;
  }
  aboutToAppear(){
    this.allAddresses=[];
    this.getAllAddresses();
  }
  build() {
    Row() {
      Column() {
        Stack({alignContent:Alignment.Start}) {
          Text('地址管理').width('100%').height(60).fontSize(20).width('100%')
            .textAlign(TextAlign.Center).fontColor(Color.Grey)
          Image($r('app.media.iv_back_selected')).width(40).height(40)
            .onClick(() => {
              router.back();
            }).margin({left:10})
        }.height(60).width('100%').margin({top:10})

        //显示地址信息
        Row(){
          List(){
            //显示默认地址
            ForEach(this.allAddresses,(item,index)=>{
              if(item.isDefault){
                ListItem(){
                  Row(){
                    Column(){
                      Text(item.addressDetail).fontColor(Color.Black).fontSize(16)
                        .height(50)
                      Row(){
                        Text(item.consignee).fontSize(12).fontColor(Color.Gray).margin({right:10})
                        Text(this.showTel(item.phone)).fontSize(12).fontColor(Color.Gray).margin({right:10})
                        if(item.isDefault){
                          Text('默认').backgroundColor(Color.Red).fontColor(Color.White).fontSize(12)
                        }
                      }.height(30)
                    }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                    Column(){
                      Text().backgroundImage($r('app.media.edit')).width(20).height(20)
                        .backgroundImageSize(ImageSize.Cover)
                        .backgroundImagePosition({x:0,y:-115})
                    }
                  }.padding({left:20,right:20,bottom:10,top:10})
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width('100%')
                  .onClick(()=>{
                    router.pushUrl({url:"pages/EditAddressPage",params:{type:'edit',address:JSON.stringify(item)}})
                  })
                }
              }
            },item=>item)
            //显示非默认地址
            ForEach(this.allAddresses,(item,index)=>{
              if(!item.isDefault){
                ListItem(){
                  Row(){
                    Column(){
                      Text(item.addressDetail).fontColor(Color.Black).fontSize(16)
                        .height(50)
                      Row(){
                        Text(item.consignee).fontSize(12).fontColor(Color.Gray).margin({right:10})
                        Text(this.showTel(item.phone)).fontSize(12).fontColor(Color.Gray).margin({right:10})
                        if(item.isDefault){
                          Text('默认').backgroundColor(Color.Red).fontColor(Color.White).fontSize(12)
                        }
                      }.height(30)
                    }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                    Column(){
                      Text().backgroundImage($r('app.media.edit')).width(20).height(20)
                        .backgroundImageSize(ImageSize.Cover)
                        .backgroundImagePosition({x:0,y:-115})
                    }
                  }.padding({left:20,right:20,bottom:10,top:10})
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width('100%')
                  .onClick(()=>{
                    router.pushUrl({url:"pages/EditAddressPage",params:{type:'edit',address:JSON.stringify(item)}})
                  })
                }
              }
            },item=>item)

          }
          .divider({ strokeWidth: 1, color: '#f1f1f1', startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .borderRadius(10)
          .margin(5)
          .backgroundColor('#ffffff')

        }.width('100%')
        .layoutWeight(1)
        .alignItems(VerticalAlign.Top)
        //显示新建地址按钮
        Row(){
          Button("新建收货地址").fontColor(Color.White).backgroundColor(Color.Red)
            .type(ButtonType.Normal)
            .width('100%')
            .borderRadius(20)
            .onClick(()=>{
              router.pushUrl({url:'pages/EditAddressPage',params:{type:'add'}})
            })
        }.alignItems(VerticalAlign.Bottom).padding(10).backgroundColor('#ffffff')
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}