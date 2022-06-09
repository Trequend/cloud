import axios, { AxiosError } from 'axios';
import { CLOUD_API_XSRF_COOKIE_NAME, CLOUD_API_XSRF_HEADER_NAME } from 'shared/config';
import { cookieExists } from 'shared/lib/cookie-exists';
import { ProblemDetails } from './models';

export const api = axios.create({
  withCredentials: true,
  xsrfCookieName: CLOUD_API_XSRF_COOKIE_NAME,
  xsrfHeaderName: CLOUD_API_XSRF_HEADER_NAME,
});

api.interceptors.request.use(async (config) => {
  if (config.xsrfCookieName === undefined) {
    throw new Error('Unable to check antiforgery token');
  }

  if (!cookieExists(config.xsrfCookieName)) {
    await requestAntiforgeryToken();
  }

  return config;
});

api.interceptors.response.use(undefined, async (error) => {
  if (!error.config || !error.config.xsrfCookieName) {
    throw new Error('Unable to check antiforgery token');
  }

  if (!cookieExists(error.config.xsrfCookieName)) {
    await requestAntiforgeryToken();
    return api.request(error.config);
  }

  throw error;
});

async function requestAntiforgeryToken(): Promise<void> {
  await axios.get('/api/v1/antiforgery');
}

export function extractProblemDetails(axiosError: AxiosError) {
  if (!axiosError.response) {
    throw new Error('Unable to extract problem details');
  }

  const data = axiosError.response.data as ProblemDetails;
  if (!data.type) {
    throw new Error('Unable to extract problem details');
  }

  return data;
}