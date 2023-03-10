package com.example.native_code_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity : FlutterActivity() {

    var channelName = "mycolor";
    var calculateTwoNumbers = "calculationChannel";
    

    fun handleMethodCall(call: MethodCall, result: Result) {
        if (call.method == "changeColor") {
            result.success("0xff60e95D")
        }
    }
    private fun add(num1:Int,num2:Int): Int {
        return num1+num2;
    }


    // fun handleBatteryCall(call: MethodCall,result: Result) {
    //     if(call.method == "batteryFunction") {
            
            
    //     }
    // }


   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)
    
         var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, calculateTwoNumbers);
         channel.setMethodCallHandler { call, result ->
             handleMethodCall(call,result);

             if (call.method == "add") {
                 val num1 = call.argument<Int>("num1")
                 val num2 = call.argument<Int>("num2")

                 if(num1!=null && num2!=null) {
                     val sum = add(num1,num2);
                     result.success(sum)
                 } else {
                     result.error("INVALID_ARGS", "Arguments cannot be null", null)
                 }
             } else {
                 result.notImplemented()
             }
         }
    }
}
