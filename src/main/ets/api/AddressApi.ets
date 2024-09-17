import http from '@ohos.net.http'
import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import { baseUrl } from './BaseData'
//获取收货地址信息
export function getAddressList(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/address/selectByOwnName`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//删除收货地址信息
export function deleteAddress(id:string){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/address/delete/${id}`,
      method:RequestMethod.DELETE,
      header:{
        Authorization:globalThis.token
      }
    })
}
//修改收货地址信息
export function editAddress(item:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/address/defaultAddressInfoUpdate`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        addressDetail:item.addressDetail,
        consignee:item.consignee,
        isDefault:item.isDefault,
        phone:item.phone,
        id:item.id
      }
    })
}
//新建收货地址信息
export function addAddress(item:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/address/add`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        addressDetail:item.addressDetail,
        consignee:item.consignee,
        isDefault:item.isDefault,
        phone:item.phone
      }
    })
}