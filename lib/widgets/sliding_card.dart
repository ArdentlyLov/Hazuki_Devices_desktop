// ================================
// 🎴 滑动卡片组件
// ================================
import 'package:flutter/material.dart';
import '../constants/app_constants.dart'; // ✅ 正确导入路径


class SlidingCard extends StatefulWidget {
  final Widget child;
  final double initialPosition;
  final double minPosition;
  final double maxPosition;
  final ValueChanged<double>? onPositionChanged;
  
  const SlidingCard({
    Key? key,
    required this.child,
    this.initialPosition = 0.5,
    this.minPosition = 0.3,
    this.maxPosition = 0.9,
    this.onPositionChanged,
  }) : super(key: key);
  
  @override
  SlidingCardState createState() => SlidingCardState();
}

class SlidingCardState extends State<SlidingCard> with SingleTickerProviderStateMixin {
  late double _currentPosition;
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;
  
  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _positionAnimation = Tween<double>(
      begin: _currentPosition,
      end: _currentPosition,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void animateToPosition(double targetPosition) {
    setState(() {
      _currentPosition = targetPosition.clamp(widget.minPosition, widget.maxPosition);
    });
    
    _positionAnimation = Tween<double>(
      begin: _currentPosition,
      end: targetPosition.clamp(widget.minPosition, widget.maxPosition),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward(from: 0.0);
    widget.onPositionChanged?.call(_currentPosition);
  }
  
  void _handleDragUpdate(DragUpdateDetails details) {
    final dragAmount = -details.primaryDelta! / MediaQuery.of(context).size.height;
    final newPosition = (_currentPosition + dragAmount).clamp(widget.minPosition, widget.maxPosition);
    
    setState(() {
      _currentPosition = newPosition;
    });
    widget.onPositionChanged?.call(_currentPosition);
  }
  
  void _handleDragEnd(DragEndDetails details) {
    final snapPositions = [widget.minPosition, widget.initialPosition, widget.maxPosition];
    double nearestPosition = snapPositions[0];
    double minDistance = double.infinity;
    
    for (final position in snapPositions) {
      final distance = (_currentPosition - position).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearestPosition = position;
      }
    }
    
    animateToPosition(nearestPosition);
  }
  
  void _togglePosition() {
    if (_currentPosition == widget.initialPosition) {
      animateToPosition(widget.maxPosition);
    } else if (_currentPosition == widget.maxPosition) {
      animateToPosition(widget.minPosition);
    } else {
      animateToPosition(widget.initialPosition);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: 0,
      right: 0,
      bottom: 0,
      top: MediaQuery.of(context).size.height * (1 - _currentPosition),
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // 卡片顶部拖拽区域
              GestureDetector(
                onTap: _togglePosition,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              
              // 卡片内容区域
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}