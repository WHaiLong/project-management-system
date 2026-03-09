import service from '@/api'

export const get = (url, params) => {
  return service({
    url,
    method: 'get',
    params
  })
}

export const post = (url, data) => {
  return service({
    url,
    method: 'post',
    data
  })
}

export const put = (url, data) => {
  return service({
    url,
    method: 'put',
    data
  })
}

export const del = (url, params) => {
  return service({
    url,
    method: 'delete',
    params
  })
}
