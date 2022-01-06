package com.example.libphonenumber_plugin;

import androidx.annotation.NonNull;

import com.google.i18n.phonenumbers.AsYouTypeFormatter;
import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberToCarrierMapper;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.Phonenumber;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * LibphonenumberPlugin
 */
public class LibphonenumberPlugin implements FlutterPlugin, MethodCallHandler {
    private static PhoneNumberUtil phoneUtil = PhoneNumberUtil.getInstance();
    private static PhoneNumberToCarrierMapper phoneNumberToCarrierMapper = PhoneNumberToCarrierMapper.getInstance();
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugin.libphonenumber");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "isValidPhoneNumber":
                this.handleIsValidPhoneNumber(call,result);
                break;
            case "getNameForNumber":
                this.handleGetNameForNumber(call,result);
                break;
            case "normalizePhoneNumber":
                this.handleNormalizePhoneNumber(call,result);
                break;
            case "getRegionInfo":
                this.handleGetRegionInfo(call,result);
                break;
            case "getNumberType":
                this.handleGetNumberType(call,result);
                break;
            case "formatAsYouType":
                this.formatAsYouType(call,result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleGetNameForNumber(MethodCall call, Result result) {
        final String phoneNumber = call.argument("phone_number");
        final String isoCode = call.argument("iso_code");

        try {
            Phonenumber.PhoneNumber p = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
            result.success(phoneNumberToCarrierMapper.getNameForNumber(p, Locale.getDefault()));
        } catch (NumberParseException e) {
            result.error("NumberParseException", e.getMessage(), null);
        }
    }

    private void handleIsValidPhoneNumber(MethodCall call, Result result) {
        final String phoneNumber = call.argument("phone_number");
        final String isoCode = call.argument("iso_code");

        try {
            Phonenumber.PhoneNumber p = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
            result.success(phoneUtil.isValidNumber(p));
        } catch (NumberParseException e) {
            result.error("NumberParseException", e.getMessage(), null);
        }
    }

    private void handleNormalizePhoneNumber(MethodCall call, Result result) {
        final String phoneNumber = call.argument("phone_number");
        final String isoCode = call.argument("iso_code");

        try {
            Phonenumber.PhoneNumber p = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
            final String normalized = phoneUtil.format(p, PhoneNumberUtil.PhoneNumberFormat.E164);
            result.success(normalized);
        } catch (NumberParseException e) {
            result.error("NumberParseException", e.getMessage(), null);
        }
    }

    private void handleGetRegionInfo(MethodCall call, Result result) {
        final String phoneNumber = call.argument("phone_number");
        final String isoCode = call.argument("iso_code");

        try {
            Phonenumber.PhoneNumber p = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
            String regionCode = phoneUtil.getRegionCodeForNumber(p);
            String countryCode = String.valueOf(p.getCountryCode());
            String formattedNumber = phoneUtil.format(p, PhoneNumberUtil.PhoneNumberFormat.NATIONAL);

            Map<String, String> resultMap = new HashMap<String, String>();
            resultMap.put("isoCode", regionCode);
            resultMap.put("regionCode", countryCode);
            resultMap.put("formattedPhoneNumber", formattedNumber);
            result.success(resultMap);
        } catch (NumberParseException e) {
            result.error("NumberParseException", e.getMessage(), null);
        }
    }

    private void handleGetNumberType(MethodCall call, Result result) {
        final String phoneNumber = call.argument("phone_number");
        final String isoCode = call.argument("iso_code");

        try {
            Phonenumber.PhoneNumber p = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
            PhoneNumberUtil.PhoneNumberType t = phoneUtil.getNumberType(p);

            switch (t) {
                case FIXED_LINE:
                    result.success(0);
                    break;
                case MOBILE:
                    result.success(1);
                    break;
                case FIXED_LINE_OR_MOBILE:
                    result.success(2);
                    break;
                case TOLL_FREE:
                    result.success(3);
                    break;
                case PREMIUM_RATE:
                    result.success(4);
                    break;
                case SHARED_COST:
                    result.success(5);
                    break;
                case VOIP:
                    result.success(6);
                    break;
                case PERSONAL_NUMBER:
                    result.success(7);
                    break;
                case PAGER:
                    result.success(8);
                    break;
                case UAN:
                    result.success(9);
                    break;
                case VOICEMAIL:
                    result.success(10);
                    break;
                case UNKNOWN:
                    result.success(-1);
                    break;
            }
        } catch (NumberParseException e) {
            result.error("NumberParseException", e.getMessage(), null);
        }
    }

    private void formatAsYouType(MethodCall call, Result result) {
        final String phoneNumber = call.argument("phone_number");
        final String isoCode = call.argument("iso_code");

        AsYouTypeFormatter asYouTypeFormatter = phoneUtil.getAsYouTypeFormatter(isoCode.toUpperCase());
        String res = null;
        for (int i = 0; i < phoneNumber.length(); i++) {
            res = asYouTypeFormatter.inputDigit(phoneNumber.charAt(i));
        }
        result.success(res);
    }
}
