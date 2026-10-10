
    final warnDisabled = !widget.dto.enable;
    final hasUnsavedChanges = _hasUnsavedChanges;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        14,
        0,
        14,
        MediaQuery.paddingOf(context).bottom + 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (warnDisabled) ...[
            _DisabledHintCard(),
            const SizedBox(height: 12),
          ],
          if (hasUnsavedChanges) ...[
            const _UnsavedHintCard(),
            const SizedBox(height: 10),
          ],
          Text(
            context.l10n.websites_defaultDocumentOrderHint,
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: AppColors.secondaryLabel(context),
            ),
          ),
          const SizedBox(height: 10),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground(
                context,
              ).withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.separator(context).withValues(alpha: 0.16),
                width: 0.5,
              ),
            ),
            child: _entries.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.websites_noDefaultDocumentEntries,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryLabel(context),
                      ),
                    ),
                  )
                : Localizations.override(
                    context: context,
                    delegates: const [DefaultMaterialLocalizations.delegate],
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      buildDefaultDragHandles: false,
                      itemCount: _entries.length,
                      onReorderItem: (oldIndex, newIndex) {
                        if (_isEditing) {
                          showAppWarningToast(
                            context.l10n.websites_cannotDragWhileEditing,
                          );
                          return;
                        }
                        setState(() {
                          final item = _entries.removeAt(oldIndex);
                          _entries.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (context, index) {
                        final e = _entries[index];
                        final isEditing = _editingId == e.id;
                        return ReorderableDelayedDragStartListener(
                          key: ValueKey(e.id),
                          index: index,
                          child: _IndexRow(
                            isEditing: isEditing,
                            name: e.name,
                            editingController: _editingController,
                            onEdit: () => _editEntry(e.id),
                            onDelete: () => _removeAt(e.id),
                            onCancel: _cancelEdit,
                            onConfirm: _confirmEdit,
                          ),
                        );
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          _SaveButton(
            saving: _saving,
            hasUnsavedChanges: hasUnsavedChanges,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}

class _DisabledHintCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = CupertinoColors.systemOrange.resolveFrom(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
