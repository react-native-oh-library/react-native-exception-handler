/*
 * MIT License
 *
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import ExceptionHandlerTurboModule from './NativeExceptionHandler'
import { Platform } from "react-native";

const noop = () => { };

export const setJSExceptionHandler = (handler = noop, allowedInDevMode = false) => {
  if (typeof allowedInDevMode !== "boolean" || typeof handler !== "function") {
    console.log("setJSExceptionHandler is called with wrong argument types.. first argument should be callback function and second argument is optional should be a boolean");
    console.log("Not setting the JS handler .. please fix setJSExceptionHandler call");
    return;
  }
  const allowed = allowedInDevMode ? true : !__DEV__;
  if (allowed) {
    ErrorUtils.setGlobalHandler(handler);
    const consoleError = console.error;
    console.error = (...args) => {
      consoleError(...args);
    };
  } else {
    console.log("Skipping setJSExceptionHandler: Reason: In DEV mode and allowedInDevMode = false");
  }
};

export const getJSExceptionHandler = () => ErrorUtils.getGlobalHandler();

export const setNativeExceptionHandler = (handler = noop, forceAppQuit = true, executeDefaultHandler = false) => {
  if (typeof handler !== "function" || typeof forceAppQuit !== "boolean") {
    console.log("setNativeExceptionHandler is called with wrong argument types.. first argument should be callback function and second argument is optional should be a boolean");
    console.log("Not setting the native handler .. please fix setNativeExceptionHandler call");
    return;
  }
  if (Platform.OS === "ios") {
    ExceptionHandlerTurboModule.setHandlerforNativeException(handler, executeDefaultHandler);
  } else {
    ExceptionHandlerTurboModule.setHandlerforNativeException(handler, forceAppQuit, executeDefaultHandler);
  }
};

export default {
  setJSExceptionHandler,
  getJSExceptionHandler,
  setNativeExceptionHandler
};
