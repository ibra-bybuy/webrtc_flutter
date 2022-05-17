import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_demo/core/components/dialogs/accept_dialog.dart';
import 'package:flutter_webrtc_demo/core/components/dialogs/call_dailog.dart';
import 'package:flutter_webrtc_demo/core/components/dialogs/invite_dialog.dart';
import 'package:flutter_webrtc_demo/core/cubits/call/call_cubit.dart';
import 'package:flutter_webrtc_demo/core/cubits/call/call_state.dart';
import 'package:flutter_webrtc_demo/core/cubits/camera_switcher/camera_switcher_cubit.dart';
import 'package:flutter_webrtc_demo/core/cubits/flash/flash_cubit.dart';
import 'package:flutter_webrtc_demo/core/cubits/mute_mic/mute_mic.dart';
import 'package:flutter_webrtc_demo/core/cubits/turn_camera/turn_camera.dart';
import 'package:flutter_webrtc_demo/core/cubits/video_recorder/video_recorder.dart';
import 'package:flutter_webrtc_demo/core/functions/platform/current_platform.dart';
import 'package:flutter_webrtc_demo/core/functions/rtc/capture_frame.dart';
import 'package:flutter_webrtc_demo/providers/foreground_service.dart';
import 'package:flutter_webrtc_demo/providers/signaling.dart';
import 'package:flutter_webrtc_demo/screens/webrtc/components/other_video_card.dart';
import 'package:flutter_webrtc_demo/screens/webrtc/components/screenshot_btn.dart';
import 'package:flutter_webrtc_demo/screens/webrtc/components/switch_camera_btn.dart';

import 'components/call_btn.dart';
import 'components/flash_btn.dart';
import 'components/my_video_card.dart';
import 'components/record_btn.dart';

class GetUserMediaSample extends StatefulWidget {
  final String host;
  const GetUserMediaSample({Key? key, required this.host}) : super(key: key);

  @override
  _GetUserMediaSampleState createState() => _GetUserMediaSampleState();
}

class _GetUserMediaSampleState extends State<GetUserMediaSample> {
  final CallCubit callCubit = CallCubit();
  late final CameraSwitchCubit cameraSwitchCubit =
      CameraSwitchCubit(callCubit.myVideoRenderer);
  late final SignalingProvider signalingProvider;
  late final VideoRecorderCubit videoRecorder =
      VideoRecorderCubit(callCubit.myVideoRenderer);
  late final FlashCubit flashCubit = FlashCubit(callCubit.myVideoRenderer);
  late final MuteMicCubit muteMicCubit =
      MuteMicCubit(callCubit.myVideoRenderer, true);
  late final TurnCameraCubit turnCameraCubit =
      TurnCameraCubit(callCubit.myVideoRenderer, true);
  ForegroundService? foregroundService;

  @override
  void initState() {
    super.initState();
    _initSignaling();
  }

  void _initSignaling() {
    signalingProvider = SignalingProvider(
      callCubit,
      widget.host,
      onRinging: ShowAcceptDialog(context).call,
      onHangup: () {
        foregroundService?.stop();
        Navigator.of(context).popUntil((route) => route.isCurrent);
      },
      onInvite: () {
        ShowInviteDialog(
          context,
          onCancel: () {
            Navigator.of(context).pop();
            signalingProvider.hangUp();
          },
        ).call();
      },
      onConnected: () {
        Navigator.of(context).pop();
      },
      onMicOff: () {
        muteMicCubit.muteMic(force: false);
      },
    )..init();
  }

  void _hangup() {
    foregroundService?.stop();
    signalingProvider.hangUp();
  }

  @override
  Future<void> deactivate() async {
    signalingProvider.deactivate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraSwitchCubit, CameraType>(
      bloc: cameraSwitchCubit,
      builder: (context, cameraState) {
        return BlocBuilder<CallCubit, CallCubitState>(
          bloc: callCubit,
          builder: (context, callState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Звонок'),
                actions: callState.isCalling
                    ? [
                        if (flashCubit.isFlashAvailable(cameraState)) ...[
                          BlocBuilder<FlashCubit, bool>(
                            bloc: flashCubit,
                            builder: (context, flashState) {
                              return FlashBtn(
                                isFlashOn: flashState,
                                onPressed: () async {
                                  await flashCubit.setFlash(!flashState);
                                },
                              );
                            },
                          ),
                        ],
                        if (CurrentPlatform.isMobile) ...[
                          SwitchCameraBtn(
                            onPressed: () async {
                              await cameraSwitchCubit.switchCam();

                              if (flashCubit.isFlashOn) {
                                await flashCubit.setFlash(false);
                              }
                            },
                          ),
                        ],
                        ScreenshotBtn(
                          onPressed: () =>
                              CaptureFrame(callCubit.myVideoRenderer)
                                  .call(context),
                        ),
                        if (videoRecorder.isRecordingAvailable) ...[
                          BlocBuilder<VideoRecorderCubit, bool>(
                            bloc: videoRecorder,
                            builder: (context, videoRecorderState) {
                              return RecordBtn(
                                isRecording: videoRecorderState,
                                onPressed: () async {
                                  videoRecorderState
                                      ? await videoRecorder.stopRecording()
                                      : await videoRecorder.startRecording();
                                },
                              );
                            },
                          ),
                        ],
                      ]
                    : null,
              ),
              body: OrientationBuilder(builder: (context, orientation) {
                if (callState.isCalling) {
                  return Container(
                    child: Stack(
                      children: [
                        OtherVideoCard(
                          callState.myAsMain
                              ? callCubit.myVideoRenderer
                              : callCubit.remoteRenderers.isNotEmpty
                                  ? callCubit
                                      .remoteRenderers.first.videoRenderer
                                  : callCubit.myVideoRenderer,
                          mirror: callState.myAsMain &&
                              cameraSwitchCubit.isFaceMode,
                          stackChildren: [
                            if (!callState.myAsMain) ...[
                              Positioned(
                                left: 10,
                                top: 50,
                                child: IconButton(
                                  color: Colors.red,
                                  onPressed: () => signalingProvider.turnMicOff(
                                    callState.remoteRenderers.first.id,
                                  ),
                                  icon: Icon(Icons.mic_off),
                                ),
                              ),
                            ],
                          ],
                        ),
                        MyVideoCard(
                          !callState.myAsMain
                              ? callCubit.myVideoRenderer
                              : callCubit.remoteRenderers.isNotEmpty
                                  ? callCubit
                                      .remoteRenderers.first.videoRenderer
                                  : callCubit.myVideoRenderer,
                          mirror: !callState.myAsMain &&
                              cameraSwitchCubit.isFaceMode,
                          onTap: () =>
                              callCubit.setMyAsMain(!callState.myAsMain),
                        ),
                      ],
                    ),
                  );
                }

                return Center(
                  child: Text("Your ID: ${callState.myRenderer.id}"),
                );
              }),
              floatingActionButton: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (callState.isCalling) ...[
                    BlocBuilder<TurnCameraCubit, bool>(
                      bloc: turnCameraCubit,
                      builder: (context, videoState) {
                        return FloatingActionButton(
                          onPressed: () => videoState
                              ? turnCameraCubit.turnOff()
                              : turnCameraCubit.turnOn(),
                          child: Icon(
                              videoState ? Icons.videocam_off : Icons.videocam),
                        );
                      },
                    ),
                    const SizedBox(width: 30.0),
                    BlocBuilder<MuteMicCubit, bool>(
                      bloc: muteMicCubit,
                      builder: (context, micState) {
                        return FloatingActionButton(
                          onPressed: () => muteMicCubit.muteMic(),
                          child: Icon(micState ? Icons.mic_off : Icons.mic),
                        );
                      },
                    ),
                    const SizedBox(width: 30.0),
                  ],
                  CallBtn(
                    isCalling: callState.isCalling,
                    onPressed: () {
                      if (callState.isCalling) {
                        _hangup();
                      } else {
                        CallDialog(
                          context,
                          (ctx, peerId, shareScreen) async {
                            Navigator.of(ctx).pop();
                            if (peerId.isNotEmpty) {
                              bool call = true;

                              if (shareScreen) {
                                foregroundService =
                                    ForegroundService(title: "Вызов");
                                call = await foregroundService!.start();
                              }

                              if (call) {
                                signalingProvider.inviteById(peerId,
                                    useScreen: shareScreen);
                              }

                              //signalingProvider.makeCall();
                            }
                          },
                          peers: callState.peers,
                          myId: callState.myRenderer.id,
                        ).call();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
