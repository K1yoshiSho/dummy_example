import 'dart:async';

import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/services/router_service.dart';
import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/feature/ispect/ispect_page.dart';
import 'package:flutter/material.dart';

/// state for the invoker widget (defaults to alwaysOpened)
///
/// `alwaysOpened`:
/// This will force the the invoker widget to be opened always
///
/// `collapsible`:
/// This will make the widget to collapse and expand on demand
/// By default it will be in collapsed state
/// Tap or outwards will expand the widget
/// When expanded, tapping on it will navigate to Infospect screen.
/// And swiping it inwards will change it to collapsed state
///
/// `autoCollapse`: This will auto change the widget state from expanded to collapse after 5 seconds
/// By default it will be in collapsed state
/// Tap or outwards will expand the widget and if not tapped within 5 secs, it will change to
/// collapsed state.
/// When expanded, tapping on it will navigate to Infospect screen and will change it to
/// collapsed state
/// And swiping it inwards will change it to collapsed state
enum InvokerState { alwaysOpened, collapsible, autoCollapse }

/// A StatefulWidget that serves as a UI invoker for the Infospect tool.
/// Depending on the platform and configuration, it displays a floating action-like button
/// which when tapped or dragged can invoke the Infospect tool.
class DraggableButton extends StatefulWidget {
  final Widget child;
  final InvokerState state;
  final ThemeData theme;
  final bool isEnabled;

  const DraggableButton({
    required this.child,
    required this.theme,
    this.isEnabled = false,
    super.key,
    this.state = InvokerState.autoCollapse,
  });

  @override
  State<DraggableButton> createState() => _InfospectInvokerState();
}

class _InfospectInvokerState extends State<DraggableButton> {
  double xPos = 0.0;
  double yPos = 600.0;
  bool isCollapsed = false;
  Timer? collapseTimer;

  @override
  void initState() {
    super.initState();
    if (widget.state == InvokerState.autoCollapse) {
      startAutoCollapseTimer();
    }
  }

  void startAutoCollapseTimer() {
    cancelAutoCollapseTimer();
    collapseTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        isCollapsed = true;
      });
    });
  }

  void cancelAutoCollapseTimer() => collapseTimer?.cancel();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return widget.isEnabled
        ? GestureDetector(
            onTap: () {
              if (widget.state != InvokerState.alwaysOpened) {
                setState(() {
                  if (!isCollapsed) {
                    isCollapsed = true;
                    if (widget.state == InvokerState.autoCollapse) {
                      startAutoCollapseTimer();
                    }
                  }
                });
              }
            },
            child: Stack(
              children: [
                widget.child,
                Positioned(
                  top: yPos,
                  left: (xPos < 50) ? xPos : null,
                  right: (xPos > 50) ? screenWidth - xPos - 50 : null,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if (!isCollapsed) {
                        setState(() {
                          xPos += details.delta.dx;
                          yPos += details.delta.dy;
                        });
                      }
                    },
                    onPanEnd: (details) {
                      if (!isCollapsed) {
                        final screenWidth = MediaQuery.sizeOf(context).width;
                        const buttonWidth = 50;

                        final halfScreenWidth = screenWidth / 2;
                        double targetXPos;

                        if (xPos + buttonWidth / 2 < halfScreenWidth) {
                          targetXPos = 0;
                        } else {
                          targetXPos = screenWidth - buttonWidth;
                        }

                        setState(() {
                          xPos = targetXPos;
                        });

                        if (widget.state == InvokerState.autoCollapse) {
                          startAutoCollapseTimer();
                        }
                      }
                    },
                    onTap: () {
                      setState(() {
                        isCollapsed = !isCollapsed;
                        if (isCollapsed) {
                          cancelAutoCollapseTimer();
                          _launchInfospect();
                        } else if (widget.state == InvokerState.autoCollapse) {
                          startAutoCollapseTimer();
                        }
                      });
                    },
                    child: AnimatedContainer(
                      width: isCollapsed ? 50 * 0.2 : 50,
                      height: 50,
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: widget.theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: !isCollapsed
                          ? const Icon(
                              Icons.monitor_heart,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          )
        : widget.child;
  }

  @override
  void dispose() {
    collapseTimer?.cancel();
    super.dispose();
  }

  void _launchInfospect() {
    if (isCollapsed) {
      if (routerService.currentRoute.contains("logger")) {
        Toaster.showToast(context, title: context.l10n.you_already_in_logger);
        return;
      } else {
        navigatorKey.currentContext?.pushNamed(ISpectPage.name);
      }
    }
  }
}
