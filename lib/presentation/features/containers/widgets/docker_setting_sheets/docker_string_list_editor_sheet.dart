  void dispose() {
    for (final item in _items) {
      item.controller.dispose();
    }
    super.dispose();
  }

  void _add() {
    setState(() {
      _items.add(_EditableItem(id: _seq++, value: ''));
    });
  }

  void _remove(int index) {
    setState(() {
      _items[index].controller.dispose();
      _items.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  void _confirm() {
    final result = _items
        .map((e) => e.controller.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return ActionSheetScaffold(
      isAdaptive: true,
      maxHeightFactor: 0.6,
      showHandle: false,
      contentPadding: EdgeInsets.zero,
      panelHeader: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
        child: Row(
          children: [
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.l10n.common_cancel,
                style: TextStyle(
                  color: AppColors.secondaryLabel(context),
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.label(context),
                ),
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: _confirm,
              child: Text(
                context.l10n.common_confirm,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    TablerIcons.list,
                    size: 32,
                    color: AppColors.tertiaryLabel(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.containers_noData,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryLabel(context),
                    ),
                  ),
                ],
              ),
            )
          else
            Localizations.override(
              context: context,
              delegates: const [DefaultMaterialLocalizations.delegate],
              child: ReorderableListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                proxyDecorator: (child, index, animation) => child,
                itemCount: _items.length,
                onReorderItem: _onReorder,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ReorderableDragStartListener(
                    key: ValueKey(item.id),
                    index: index,
                    child: _StringListRow(
                      controller: item.controller,
                      placeholder: widget.placeholder.isEmpty
                          ? context.l10n.containers_inputAddress
                          : widget.placeholder,
                      onDelete: () => _remove(index),
                    ),
