import 'dart:developer';
import 'package:down/cubit/cubit/dwonload_cubit/download_cubit.dart';
import 'package:down/cubit/cubit/get_data_cubit.dart';
import 'package:down/show_data.dart';
import 'package:down/utils/custom/field_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTextNotEmpty = false;
  bool _isTextEmptyError = false;
  final youtubeRegex = RegExp(
    r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$',
  );
  bool isSearch = false;
  double progress = 0;
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextNotEmpty = _controller.text.isNotEmpty;
      _isTextEmptyError = false;
      isSearch = false;
    });
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isTextEmptyError = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _isTextEmptyError = true;
      });
    } else if (!youtubeRegex.hasMatch(_controller.text)) {
      setState(() {
        _isTextEmptyError = true;
      });
    } else {
      FocusScope.of(context).unfocus();

      setState(() {
        isSearch = true;
      });
      context.read<GetDataCubit>().fetchDate(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dwon',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Tech',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: UrlInputField(
                      controller: _controller,
                      focusNode: _focusNode,
                      isTextNotEmpty: _isTextNotEmpty,
                      isTextEmptyError: _isTextEmptyError,
                    ),
                  ),
                  SubmitButton(
                    isTextNotEmpty: _isTextNotEmpty,
                    onPressed: _submit,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              isSearch
                  ? BlocConsumer<GetDataCubit, GetDataState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        if (state is GetDataSuccses) {
                          return SingleChildScrollView(
                              child: BlocProvider(
                            create: (context) => DownloadCubit(),
                            child: ShowData(
                              image: state.image,
                              title: state.tittel,
                              sizeA: state.sizeAudio,
                              sizev: state.sizeVideo,
                              time: state.time,
                              url: _controller.text,
                            ),
                          ));
                        } else if (state is GetDataFail) {
                          return const Center(
                            child: Text(
                              'No Wi-Fi connection. Please connect to Wi-Fi to continue.',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator(
                            color: Colors.grey,
                          );
                        }
                      },
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
