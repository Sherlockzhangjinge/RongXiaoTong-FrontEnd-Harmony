import http from '@ohos.net.http'
import {HttpManager} from '../util/HttpManager'
import { RequestMethod } from '../util/RequestOption'
import { baseUrl } from './BaseData'
//获取用户列表信息
export function findAllUser(){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/user/search/1`,
      method:RequestMethod.GET,
      header:{
        Authorization:globalThis.token
      }
    })
}
//修改用户信息信息
export function updateUserInfo(user:any){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/user/${user.userName}`,
      method:RequestMethod.PUT,
      header:{
        Authorization:globalThis.token
      },
      extraData:{
        address:user.address,
        identityNum:user.identityNum,
        nickName:user.nickName,
        phone:user.phone,
        role:user.role,
        user_name:user.userName
      }
    })
}
//删除用户信息
export function deleteUserInfo(userName:string){
  return HttpManager.getInstance()
    .request({
      url:`${baseUrl}/user/${userName}`,
      method:RequestMethod.DELETE,
      header:{
        Authorization:globalThis.token
      }
    })
}
