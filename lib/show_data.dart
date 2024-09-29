import 'dart:developer';

import 'package:down/cubit/cubit/dwonload_cubit/download_cubit.dart';
import 'package:down/utils/custom/shar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowData extends StatefulWidget {
  ShowData(
      {super.key,
      required this.image,
      required this.sizeA,
      required this.url,
      required this.sizev,
      required this.time,
      required this.title});
  String image;
  String title;
  String sizev;
  String sizeA;
  Duration time;
  String url;
  bool isPreesd = false;
  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.02;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      child: Column(
        children: [
          Image.network(
            widget.image,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            formatDuration(widget.time),
            style: TextStyle(fontSize: screenWidth * 0.05),
          ),
          const SizedBox(
            height: 30,
          ),
          BlocConsumer<DownloadCubit, DownloadState>(
            listener: (context, state) {
              if (state is DownloadSuccses) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.msg)));
              }
            },
            builder: (context, state) {
              if (state is DownloadLooding) {
                return const Center(
                    child: LinearProgressIndicator(
                  minHeight: 20,
                  color: Colors.grey,
                ));
              } else if (state is DownloadProgress) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          LinearProgressIndicator(
                            minHeight: 20,
                            value: state.progress,
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                          Text(
                            '${(state.progress * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              } else if (state is DownloadSuccses) {
                return massageWidget(
                    icons: Icon(Icons.check,
                        size: screenWidth * 0.09,
                        color: const Color.fromARGB(255, 32, 121, 15)),
                    msg: "Dwonload Sucssafly",
                    screenWidth: screenWidth,
                    color: const Color.fromARGB(255, 32, 121, 15));
              } else if (state is DownloadFail) {
                return massageWidget(
                    icons: Icon(Icons.close,
                        size: screenWidth * 0.09, color: Colors.red),
                    msg: "Pleas Cheack Wifi",
                    screenWidth: screenWidth,
                    color: Colors.red);
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    button(
                      context: context,
                      size: widget.sizev,
                      tittel: "Vedio",
                      onPressed: () {
                        context
                            .read<DownloadCubit>()
                            .downlowadVidio(widget.url);
                      },
                    ),
                    button(
                      size: widget.sizeA,
                      tittel: "Audio",
                      context: context,
                      onPressed: () {
                        log(widget.url);
                        context.read<DownloadCubit>().downloadAudio(widget.url);
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
