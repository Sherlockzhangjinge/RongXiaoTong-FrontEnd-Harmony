import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import geoLocationManager from '@ohos.geoLocationManager';
// 填写自己的Apk Key
const  apiKey = 'DAEDALKrA5n+WvU62NC2DZFGGCvcOZv9u331BydLrPrDTdivgZdg3g8xHFhizQDhSasJgarMuyIqb1i7SggpC8MBxAQpi2wCEvRPuw=='
//获取IP信息
export function getMyIP(){
  return HttpManager.getInstance()
    .request({url:'http://checkip.amazonaws.com/'})
}
// 获取经纬度信息和城市信息
export function getLocation(ip:string){
  return HttpManager.getInstance()
    .request({
      url:'https://openlocation-drcn.platform.dbankcloud.com/networklocation/v1/ipLocation',
      method:RequestMethod.POST,
      header:{
        'Authorization':`Bearer ${apiKey}`,
        'Content-Type':'application/json',
        'x-forwarded-for':`${ip}`
      },
      extraData:{
        ip:ip
      }
    })
}
// // 根据地点名获取经纬度 模拟器测不了
// export function  getlatlng(locationName:string){
//   return new Promise((resolve, reject) => {
//     geoLocationManager.getAddressesFromLocationName({
//       locale:'zh',
//       description:locationName,
//
//     },(err,list)=>{
//       if(!err){
//         resolve(list)
//       }else{
//         reject(err)
//       }
//     })
//   })
//
// }
// 根据地点名获取经纬度
export function  getlatlng(locationName:string){
  return HttpManager.getInstance()
    .request({
      url:`https://siteapi.cloud.huawei.com/mapApi/v1/siteService/geocode`,
      method:RequestMethod.POST,
      header:{
        'Authorization':`Bearer ${apiKey}`,
        'Content-Type':'application/json',
      },
      extraData:{
        address:locationName
      }
    })

}
