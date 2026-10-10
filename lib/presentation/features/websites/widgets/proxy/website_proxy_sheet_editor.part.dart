                    controller: _browserCacheTimeController,
                    unit: _browserCacheUnit,
                    onUnitChanged: (value) =>
                        setState(() => _browserCacheUnit = value),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _FormSection(
              icon: TablerIcons.world_share,
              title: context.l10n.websites_corsAccess,
              children: [
                _CompactSwitchTile(
                  icon: TablerIcons.shield_check,
                  title: context.l10n.websites_enableCors,
                  value: _cors,
                  onChanged: (v) => setState(() => _cors = v),
                ),
                if (_cors) ...[
                  _CompactInputField(
                    label: context.l10n.websites_allowedOrigins,
                    icon: TablerIcons.world,
                    controller: _allowOriginsController,
                    required: true,
                    hint: context.l10n.websites_allowedOriginsHint,
                  ),
                  _CompactMethodsField(
                    selectedMethods: _allowMethods,
                    onToggle: (method) {
                      setState(() {
                        if (_allowMethods.contains(method)) {
                          _allowMethods.remove(method);
                        } else {
                          _allowMethods.add(method);
                        }
                      });
                    },
                  ),
                  _CompactInputField(
                    label: context.l10n.websites_allowedHeaders,
                    icon: TablerIcons.file_code,
                    controller: _allowHeadersController,
                    hint: 'Content-Type,Authorization',
                  ),
                  _CompactSwitchTile(
                    icon: TablerIcons.cookie,
                    title: context.l10n.websites_allowCredentials,
                    value: _allowCredentials,
                    onChanged: (v) => setState(() => _allowCredentials = v),
                  ),
                  _CompactSwitchTile(
                    icon: TablerIcons.bolt,
                    title: context.l10n.websites_preflightFastResponse,
                    value: _preflight,
                    onChanged: (v) => setState(() => _preflight = v),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            _FormSection(
              icon: TablerIcons.replace,
              title: context.l10n.websites_textReplacement,
              action: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                onPressed: () => setState(() {
                  _replaces.add(
                    _ReplaceRule(id: _replaceSeq++, search: '', replace: ''),
                  );
                }),
                child: Text(context.l10n.websites_add),
              ),
              children: [
                if (_replaces.isEmpty)
                  _CompactEmptyHint(text: context.l10n.websites_noReplaceRules)
                else
                  Localizations.override(
                    context: context,
                    delegates: const [DefaultMaterialLocalizations.delegate],
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: _replaces.length,
                      onReorderItem: (oldIndex, newIndex) {
                        setState(() {
                          final item = _replaces.removeAt(oldIndex);
                          _replaces.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = _replaces[index];
                        return ReorderableDragStartListener(
                          key: ValueKey(item.id),
                          index: index,
                          child: _ReplaceRow(
                            item: item,
                            onDelete: () =>
                                setState(() => _replaces.removeAt(index)),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
