
import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import { baseUrl } from './BaseData'


//修改个人信息
export function editUserInfo(info:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/user/loginUpdateByUsername`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        address:info.address,
        avatar:info.avatar,
        identityNum:info.identityNum,
        nickName:info.nickName,
        phone:info.phone,
        realName:info.realName
      }
    })
}
//修改密码
export function updatePassword(newPassword,oldPassword){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/user/loginUpdatePassword`,
      method:RequestMethod.POST,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        newPassword:newPassword,
        oldPassword:oldPassword
      }
    })
}
