import 'package:community_social_media/const/context_extension.dart';
import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../models/event_model.dart';

class EventItemWidget extends StatefulWidget {
  const EventItemWidget({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  State<EventItemWidget> createState() => _EventItemWidgetState();
}

class _EventItemWidgetState extends State<EventItemWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Card(
        color: Colors.white.withOpacity(0.8),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              _itemHeader(context),
              _itemBody(context),
              _itemBottom(),
              if (widget.event.description != null) _itemDescription(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemBottom() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
            icon: Icon(
              isLiked != true
                  ? Icons.favorite_border_rounded
                  : Icons.favorite_outlined,
              size: 25,
              color: Colors.black,
            )),
        const SizedBox(
          width: 5,
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 25,
              color: Colors.black,
            ))
      ],
    );
  }

  Padding _itemDescription(BuildContext context) {
    debugPrint('${widget.event.description}');
    return Padding(
      padding: context.paddingHorizontalLow,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${widget.event.description}',
          maxLines: 3,
          style: context.textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _itemBody(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 16,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
                image: NetworkImage(widget.event.eventImageUrl!),
                fit: BoxFit.fill)),
      ),
    );
  }

  Widget _itemHeader(BuildContext context) {
    Color iconColor = Colors.blue;
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: widget.event.organizerImage != null &&
                            widget.event.organizerImage != ""
                        ? ClipOval(
                            child: Image.network(widget.event.organizerImage!))
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                  Padding(
                    padding: context.paddingLeftLow,
                    child: Text(
                      widget.event.organizer ?? 'User Name',
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 35,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
