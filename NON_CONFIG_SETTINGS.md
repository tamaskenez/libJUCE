# JUCE settings not tagged `Config:`

These are macros the module sources read with `#ifdef`/`#ifndef`/`#if` but that the module headers don't declare as `Config:` options.

Decision values: **L** = library build time (becomes a CMake option and is checked in `prebuilt_config_check.cpp`), **C** = consumer side (left as it is), **—** = not a setting.

Decisions marked **L (Projucer)** are settings that the Projucer exposes in its UI and turns into a define (see the section at the end). Library build-time options are also passed on to consumers as PUBLIC compile definitions, so consumer code can test them.

Unless the *Value* column says otherwise, the macro is a 0/1 flag. The current option mechanism only handles 0/1, so string and integer values would need an extension.

## 1. Read in public headers (consumer code and the library must agree)

| Macro | Module(s) | Default | Value | Notes | Decision |
|---|---|---|---|---|---|
| `JUCE_STRING_UTF_TYPE` | core | 8 | 8/16/32 | `String` internal encoding, changes the ABI | |
| `JUCE_MODAL_LOOPS_PERMITTED` | core, events, gui_basics, gui_extra, audio_processors, video | 0 | | adds or removes API (`runModalLoop`, …) | |
| `JUCE_DISABLE_ASSERTIONS` | core, gui_basics, opengl, audio_processors_headless | 0 | | `jassert` and assertion-only members | |
| `JUCE_USE_SSE_INTRINSICS` | core, audio_basics | auto (1 on x86) | | `juce_TargetPlatform.h` | |
| `JUCE_USE_ARM_NEON` | core, audio_basics, audio_formats, dsp | auto (1 on ARM) | | `juce_TargetPlatform.h` | |
| `JUCE_USE_VDSP_FRAMEWORK` | core, audio_basics, dsp | 1 on Apple | | | |
| `JUCE_USE_SIMD` | dsp | 1 | | `dsp::SIMDRegister` availability | |
| `JUCE_NO_INLINE_ASM` | core | 0 | | `ByteOrder` (header) + SystemStats | |
| `JUCE_UNIT_TESTS` | almost all | 0 | | test classes; APVTS header | |
| `JUCE_PUSH_NOTIFICATIONS` | events, gui_basics, gui_extra | 0 | | implemented as a CMake option owned by `juce_events`; `juce_gui_basics` and `juce_gui_extra` get it through their dependency | L (Projucer) |
| `JUCE_IN_APP_PURCHASES` | product_unlocking, gui_basics | 0 | | already implemented as a CMake option (replaces `NEEDS_STORE_KIT`) | L (Projucer) |
| `JUCE_INCLUDE_OGGVORBIS_CODE` | audio_formats | 1 | | sibling of the tagged `JUCE_INCLUDE_FLAC_CODE` | |
| `JUCE_ZLIB_INCLUDE_PATH` | core | `<zlib.h>` | path | used when `JUCE_INCLUDE_ZLIB_CODE=0` | |
| `JUCE_PNGLIB_INCLUDE_PATH`, `JUCE_JPEGLIB_INCLUDE_PATH`, `JUCE_WEBPLIB_DECODE_INCLUDE_PATH`, `JUCE_WEBPLIB_ENCODE_INCLUDE_PATH` | graphics | `<png.h>` … | path | used when `JUCE_INCLUDE_*LIB_CODE=0` | |
| `JUCE_FLAC_INCLUDE_PATH` | audio_formats | `<FLAC/all.h>` | path | | |
| `JUCE_LADSPA_INCLUDE_PATH` | audio_processors_headless | `<ladspa.h>` | path | | |
| `JUCE_DISABLE_AUDIOPROCESSOR_BEGIN_END_GESTURE_CHECKING` | audio_processors_headless | 0 | | `AudioProcessor.h` | |
| `JUCE_DISABLE_CAUTIOUS_PARAMETER_ID_CHECKING` | audio_processors_headless | 0 | | `AudioProcessor.h` | |
| `JUCE_USE_ANDROID_OBOE_STABILIZED_CALLBACK` | audio_devices | 0 | | | |
| `JUCE_CAMERA_LOG_ENABLED`, `JUCE_VIDEO_LOG_ENABLED` | video | 0 / 1 | | logging | |
| `JUCE_VST3_DEBUGGING`, `JUCE_VST_FALLBACK_HOST_NAME`, `JUCE_VST_WRAPPER_INVOKE_MAIN`, `JUCE_VST_WRAPPER_LOAD_CUSTOM_MAIN` | audio_processors_headless | | string / code | VST hosting implementation headers | |
| `JUCE_APP_CONFIG_HEADER` | core | unset | path | injects an AppConfig-style header into every TU; probably should be an error with prebuilt modules | |
| `JUCE_DLL`, `JUCE_DLL_BUILD`, `JUCE_DISABLE_DLL_ALLOCATORS` | core, gui_basics | unset | | DLL builds only; out of scope for static libraries | |
| `JUCE_DEFINE_T_MACRO` | core | 0 | | only defines the `T()` macro in a header; consumer side is enough | |
| `JUCE_SILENCE_XCODE_15_LINKER_WARNING` | core | unset | | only silences a header warning | |
| `JUCE_USE_CUSTOM_PLUGIN_STANDALONE_APP` | events, audio_processors, audio_plugin_client | 0 | | plugin topic, see below | |
| `JUCE_VST3_COMPATIBLE_CLASSES`, `JUCE_VST3_COMPONENT_CLASS` | audio_plugin_client, audio_processors_headless | | code | plugin topic | |

## 2. Read only in library `.cpp` files (behaviour switches)

A consumer-side definition has no effect on these, so they can only be library build time.

| Macro | Module(s) | Default | Value | Decision |
|---|---|---|---|---|
| **Features** | | | | |
| `JUCE_CONTENT_SHARING` | gui_basics | 0 | | L (Projucer), implemented |
| `JUCE_MEDIAFOUNDATION` | video | 0 | | |
| `JUCE_USE_FREETYPE`, `JUCE_USE_FONTCONFIG` | graphics (Linux) | 1 | | |
| `JUCE_FORCE_WINRT_MIDI` | audio_devices | 0 | | |
| `JUCE_DISABLE_NATIVE_FILECHOOSERS` | gui_basics | 0 | | |
| `JUCE_USE_EXTERNAL_TEMPORARY_SUBPROCESS` | gui_extra (Linux web browser) | 0 | | open: derived, not a UI setting (see below) |
| `JUCE_IN_APP_PURCHASES_USE_SANDBOX_ENVIRONMENT` | product_unlocking | 0 | | |
| `JUCE_PUSH_NOTIFICATIONS_ACTIVITY` | gui_basics (Android) | unset | string | **C**: the value is the app's activity class. Its only user is moved to `native/juce_PushNotificationsActivity_android.cpp`, which is compiled in the consumer when `juce_gui_basics` is prebuilt |
| `JUCE_FIREBASE_INSTANCE_ID_SERVICE_CLASSNAME`, `JUCE_FIREBASE_MESSAGING_SERVICE_CLASSNAME` | gui_extra (Android) | unset | flag | L (Projucer), as the combined CMake option `JUCE_PUSH_NOTIFICATIONS_FIREBASE`. The sources only test `defined (...)`, so the values never matter; the option defines both with the Projucer's fixed values |
| `JUCE_IOS_AUDIO_EXPLICIT_SAMPLERATES` | audio_devices | unset | list | |
| `JUCE_TR9_UPPERCASE_IS_RTL` | graphics | 0 | | |
| `JUCE_PLUTOVG_DISABLE_FONT_FACE_CACHE_LOAD` | graphics | 0 | | |
| `JUCE_STATIC_LINK_GL_VERSION_3_3` … `_4_6`, `JUCE_STATIC_LINK_GL_ES_VERSION_3_1`, `_3_2` | opengl | 0 | | |
| **Behaviour tweaks** | | | | |
| `JUCE_COREGRAPHICS_RENDER_WITH_MULTIPLE_PAINT_CALLS` | gui_basics (mac) | 0 | | |
| `JUCE_REMOVE_COMPONENT_FROM_DESKTOP_ON_WM_DESTROY` | gui_basics (Windows) | 0 | | |
| `JUCE_WINDOWS_ALT_KEY_TRIGGERS_MENU` | gui_basics (Windows) | 0 | | |
| `JUCE_WAV_DO_NOT_PAD_HEADER_SIZE` | audio_formats | 0 | | |
| `JUCE_DONT_ASSERT_ON_GLSL_COMPILE_ERROR` | opengl | 0 | | |
| `JUCE_WIN32_TIMER_PERIOD` | core (Windows) | 1 | int | |
| `JUCE_PREFERRED_MAX_FILE_HANDLES` | core | unset | int | |
| `JUCE_JACK_CLIENT_NAME`, `JUCE_ALSA_MIDI_NAME` | audio_devices | app name | string | |
| `JUCE_64BIT_ATOMICS_UNAVAILABLE` | core | 0 | | |
| `JUCE_DISABLE_JUCE_VERSION_PRINTING` | core | 0 | | the "JUCE v9.0.6" line at startup in Debug |
| **Logging / debugging** | | | | |
| `JUCE_ALSA_LOGGING`, `JUCE_COREAUDIO_LOGGING_ENABLED`, `JUCE_DIRECTSOUND_LOGGING`, `JUCE_WASAPI_LOGGING`, `JUCE_WINRT_MIDI_LOGGING`, `JUCE_IOS_AUDIO_LOGGING`, `JUCE_OBOE_LOG_ENABLED`, `JUCE_LOG_COREMIDI_ERRORS`, `JUCE_ASIO_DEBUGGING` | audio_devices | 0 (oboe, coremidi: 1) | | |
| `JUCE_DEBUG_KEYCODES`, `JUCE_DEBUG_XERRORS`, `JUCE_DEBUG_XERRORS_SYNCHRONOUSLY`, `JUCE_DUMP_MOUSE_EVENTS` | gui_basics | 0 | | |
| `JUCE_DIRECT2D_METRICS`, `JUCE_ETW_TRACELOGGING` | graphics, gui_basics (Windows) | 0 | | |

## 3. Plugin client (compiled on the consumer side anyway, no decision needed now)

`JUCE_DONT_AUTO_OPEN_MIDI_DEVICES_ON_MOBILE`, `JUCE_VST3_EMULATE_MIDI_CC_WITH_PARAMETERS`, `JUCE_VST_RETURN_HEX_VERSION_NUMBER_DIRECTLY`, `JUCE_USE_CUSTOM_PLUGIN_STANDALONE_ENTRYPOINT`, and all `JucePlugin_*` macros.

## 4. Not settings (for reference)

- Include guards (`JUCE_*_H_INCLUDED`).
- Platform and compiler detection: `JUCE_MAC`, `JUCE_64BIT`, `JUCE_INTEL`, `JUCE_ARM`, `JUCE_MSVC`, endianness, ….
- Internal helpers: `JUCE_API`, `JUCE_LEAK_DETECTOR`, `JUCE_PLUTOVG_BUILD(_STATIC)` (set inside `juce_graphics.cpp`), `JUCE_INTERNAL_HAS_*`.
- Set by JUCE's CMake and already passed on to consumers: `JUCE_MODULE_AVAILABLE_*`, `JUCE_GLOBAL_MODULE_SETTINGS_INCLUDED`, `JUCE_ANDROID_GL_ES_VERSION_3_0`, `JUCE_WEBVIEW_INTEROP_LIBRARY_VERSION`.
- Obsolete: `JUCE_DISPLAY_SPLASH_SCREEN` and `JUCE_USE_DARK_SPLASH_SCREEN` only trigger a warning.

## Settings the Projucer turns into defines

The Projucer exporters (`extras/Projucer/Source/ProjectSaving/`) emit these defines from project or exporter settings:

| Projucer setting | Define(s) | Where |
|---|---|---|
| In-app purchases / in-app billing | `JUCE_IN_APP_PURCHASES=1` | `jucer_ProjectExport_Xcode.h:1711`, `jucer_ProjectExport_Android.h:1651` |
| Content sharing | `JUCE_CONTENT_SHARING=1` (Xcode: iOS only) | `jucer_ProjectExport_Xcode.h:1714`, `jucer_ProjectExport_Android.h:1654` |
| Push notifications | `JUCE_PUSH_NOTIFICATIONS=1`; on Android also `JUCE_PUSH_NOTIFICATIONS_ACTIVITY="<activity class>"` | `jucer_ProjectExport_Xcode.h:1717`, `jucer_ProjectExport_Android.h:1646` |
| Remote notifications (Android) | `JUCE_FIREBASE_INSTANCE_ID_SERVICE_CLASSNAME`, `JUCE_FIREBASE_MESSAGING_SERVICE_CLASSNAME` | `jucer_ProjectExport_Android.h:1660` |

The Projucer also reads several `Config:` options to decide what to link or add to the project: `JUCE_USE_CURL`, `JUCE_LOAD_CURL_SYMBOLS_LAZILY`, `JUCE_WEB_BROWSER`, `JUCE_OPENGL_ES`, `JUCE_USE_CAMERA`, `JUCE_USE_ANDROID_OBOE`, `JUCE_USE_WIN_WEBVIEW2(_WITH_STATIC_LINKING)`, `JUCE_USE_WINDOWS_MIDI_SERVICES`, `JUCE_PLUGINHOST_*` and `JUCE_CUSTOM_VST3_SDK`. These are already library build-time options. For a prebuilt module, the system libraries, frameworks and packages they need must be linked by the library (as done for curl, webkit, GLES and StoreKit), not by the consumer.

Other defines it emits are not module settings: `JUCE_ANDROID`, `JUCE_ANDROID_API_VERSION` and `JUCE_ANDROID_GL_ES_VERSION_3_0` are platform info; `JUCE_APP_VERSION(_HEX)`, `JUCE_STANDALONE_APPLICATION` and `JUCE_SHARED_CODE` describe the target; `JUCE_MODULE_AVAILABLE_*` and `JUCE_GLOBAL_MODULE_SETTINGS_INCLUDED` are already handled; `JUCE_PROJUCER_VERSION` and `JUCE_SKIP_PRECOMPILED_HEADER` are build bookkeeping; `JUCE_QUICKTIME` is a leftover.

**Open: `JUCE_USE_EXTERNAL_TEMPORARY_SUBPROCESS`.** It isn't a UI setting. The Projucer and `juce_link_with_embedded_linux_subprocess` (`JUCEUtils.cmake:240`) set it for *plugins* that use the web browser on Linux. It is only read in `juce_gui_extra` `.cpp` files, so a prebuilt `juce_gui_extra` has to choose one value: one library build for plugins and another for apps, or a runtime switch.
