import http from '@ohos.net.http';
import { RequestOptions } from './RequestOption';

/**
 * Http请求器
 */
export class HttpCore {

  /**
   * 发送请求
   * @param requestOption
   * @returns Promise
   */
  request(requestOption: RequestOptions): Promise<http.HttpResponse> {
    return new Promise((resolve, reject) => {
      this.sendRequest(requestOption)
        .then((response) => {
          if (typeof response.result !== 'string') {
            reject(new Error('Invalid data type'));

          } else {
            //let bean: T = JSON.parse(response.result);
            if (response) {
              resolve(response);
            } else {
              reject(new Error('Invalid data type,JSON to T failed'));
            }

          }
        })
        .catch((error) => {
          reject(error);
        });
    });
  }


  private sendRequest(requestOption: RequestOptions): Promise<http.HttpResponse> {
    // 每一个httpRequest对应一个HTTP请求任务，不可复用
    let httpRequest = http.createHttp();
    let resolveFunction, rejectFunction;
    const resultPromise = new Promise<http.HttpResponse>((resolve, reject) => {
      resolveFunction = resolve;
      rejectFunction = reject;
    });

    let promise = httpRequest.request(this.appendQueryParams(requestOption.url, requestOption.queryParams), {
      method: requestOption.method,
      header: requestOption.header,
      extraData: requestOption.extraData, // 当使用POST请求时此字段用于传递内容
      //expectDataType: http.HttpDataType.STRING // 可选，指定返回数据的类型
    });

    promise.then((response) => {
      console.info('Result:' + response.result);
      console.info('code:' + response.responseCode);
      console.info('header:' + JSON.stringify(response.header));


      resolveFunction(response);

    }).catch((err) => {
      rejectFunction(err);
    }).finally(() => {
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    })
    return resultPromise;
  }

  // 将请求参数拼接到url上
  private appendQueryParams(url: string, queryParams: Record<string, string>): string {
    let param=""
    for (let queryParamsKey in queryParams) {
      if(param!=""){
        param+='&';
      }
      param+=queryParamsKey+'='+queryParams[queryParamsKey]
    }
    if(param==""){
      return url;
    }else{
      return url+'?'+param;
    }

  }
}

export const httpCore = new HttpCore();