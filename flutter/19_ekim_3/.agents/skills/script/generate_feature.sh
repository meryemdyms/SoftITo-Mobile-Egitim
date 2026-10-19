#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Susadım v1 - Feature Scaffold Otomasyon Scripti
# -----------------------------------------------------------------------------
# flutter-feature-scaffold yeteneği ve project.md kurallarına tam uyumlu
# yeni bir modül iskeleti üretir.
#
# Kurallar:
# - Clean UI & Reaktif State Katman Ayrımı (Model, Controller, View, Widgets)
# - ValueNotifier & ValueListenableBuilder State Yönetimi
# - 40 satır altı modüler Widget'lar ve const constructors
# - Otomatik Unit Test iskeleti
# -----------------------------------------------------------------------------

set -euo pipefail

# Renk tanımlamaları
COLOR_RESET="\033[0m"
COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[1;34m"
COLOR_CYAN="\033[1;36m"
COLOR_BOLD="\033[1m"

show_help() {
  echo -e "${COLOR_CYAN}${COLOR_BOLD}Susadım v1 - Flutter Feature Scaffold Üretici${COLOR_RESET}

${COLOR_YELLOW}Kullanım:${COLOR_RESET}
  $0 <feature_name> [seçenekler]

${COLOR_YELLOW}Örnekler:${COLOR_RESET}
  $0 water_tracker
  $0 workout
  $0 calorie_counter --force

${COLOR_YELLOW}Seçenekler:${COLOR_RESET}
  -f, --force    Var olan dosyaların üzerine zorla yazar.
  -h, --help     Bu yardım mesajını görüntüler.

${COLOR_YELLOW}Üretilen Dizin ve Dosyalar:${COLOR_RESET}
  lib/features/<feature_name>/
  ├── models/<feature_name>_model.dart
  ├── controllers/<feature_name>_controller.dart
  ├── views/<feature_name>_view.dart
  └── widgets/<feature_name>_widgets.dart
  test/features/<feature_name>/
  └── controllers/<feature_name>_controller_test.dart"
}

# Argüman kontrolleri
FORCE_OVERWRITE=false
FEATURE_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -f|--force)
      FORCE_OVERWRITE=true
      shift
      ;;
    -*)
      echo -e "${COLOR_RED}Hata: Geçersiz seçenek '$1'${COLOR_RESET}"
      show_help
      exit 1
      ;;
    *)
      if [[ -z "$FEATURE_NAME" ]]; then
        FEATURE_NAME="$1"
      else
        echo -e "${COLOR_RED}Hata: Birden fazla feature adı belirtilemez: '$1'${COLOR_RESET}"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$FEATURE_NAME" ]]; then
  echo -e "${COLOR_RED}Hata: Lütfen bir feature adı belirtin!${COLOR_RESET}\n"
  show_help
  exit 1
fi

# snake_case doğrulama
if [[ ! "$FEATURE_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo -e "${COLOR_RED}Hata: Modül adı küçük harfle başlamalı ve snake_case formatında olmalıdır (örn: water_tracker, workout)${COLOR_RESET}"
  exit 1
fi

# PascalCase dönüşümü
PASCAL_NAME=$(echo "$FEATURE_NAME" | awk -F'_' '{for(i=1;i<=NF;i++) printf "%s", toupper(substr($i,1,1)) substr($i,2); print ""}')

echo -e "${COLOR_BLUE}${COLOR_BOLD}=== Feature Scaffold Başlatılıyor: ${COLOR_CYAN}${FEATURE_NAME}${COLOR_BLUE} (${PASCAL_NAME}) ===${COLOR_RESET}"

# Dizin yolları
BASE_DIR="lib/features/${FEATURE_NAME}"
TEST_DIR="test/features/${FEATURE_NAME}"

MODELS_DIR="${BASE_DIR}/models"
CONTROLLERS_DIR="${BASE_DIR}/controllers"
VIEWS_DIR="${BASE_DIR}/views"
WIDGETS_DIR="${BASE_DIR}/widgets"
TEST_CONTROLLERS_DIR="${TEST_DIR}/controllers"

mkdir -p "$MODELS_DIR" "$CONTROLLERS_DIR" "$VIEWS_DIR" "$WIDGETS_DIR" "$TEST_CONTROLLERS_DIR"

MODEL_FILE="${MODELS_DIR}/${FEATURE_NAME}_model.dart"
CONTROLLER_FILE="${CONTROLLERS_DIR}/${FEATURE_NAME}_controller.dart"
VIEW_FILE="${VIEWS_DIR}/${FEATURE_NAME}_view.dart"
WIDGET_FILE="${WIDGETS_DIR}/${FEATURE_NAME}_widgets.dart"
TEST_FILE="${TEST_CONTROLLERS_DIR}/${FEATURE_NAME}_controller_test.dart"

safe_write() {
  local target="$1"
  local content="$2"

  if [[ -f "$target" && "$FORCE_OVERWRITE" != true ]]; then
    echo -e "  ${COLOR_YELLOW}⚠️  Atlandı (zaten var): ${target} (Üzerine yazmak için --force kullanın)${COLOR_RESET}"
    return
  fi

  printf "%s" "$content" > "$target"
  echo -e "  ${COLOR_GREEN}✓ Oluşturuldu:${COLOR_RESET} ${target}"
}

# 1. MODEL DOSYASI
MODEL_CONTENT=$(cat << 'EOF'
import 'package:flutter/foundation.dart';

@immutable
class PASCAL_NAMEModel {
  final String id;
  final String title;
  final int counter;
  final bool isCompleted;
  final DateTime updatedAt;

  const PASCAL_NAMEModel({
    required this.id,
    required this.title,
    required this.counter,
    required this.isCompleted,
    required this.updatedAt,
  });

  /// Başlangıç varsayılan durumu
  factory PASCAL_NAMEModel.initial({String title = 'PASCAL_NAME'}) {
    return PASCAL_NAMEModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      counter: 0,
      isCompleted: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Değişmez kopya oluşturucu
  PASCAL_NAMEModel copyWith({
    String? id,
    String? title,
    int? counter,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return PASCAL_NAMEModel(
      id: id ?? this.id,
      title: title ?? this.title,
      counter: counter ?? this.counter,
      isCompleted: isCompleted ?? this.isCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// JSON fabrikası
  factory PASCAL_NAMEModel.fromJson(Map<String, dynamic> json) {
    return PASCAL_NAMEModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      counter: json['counter'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// JSON çıktısı
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'counter': counter,
      'isCompleted': isCompleted,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
EOF
)
MODEL_CONTENT="${MODEL_CONTENT//PASCAL_NAME/${PASCAL_NAME}}"
safe_write "$MODEL_FILE" "$MODEL_CONTENT"

# 2. CONTROLLER DOSYASI
CONTROLLER_CONTENT=$(cat << 'EOF'
import 'package:flutter/foundation.dart';
import '../models/FEATURE_NAME_model.dart';

/// PASCAL_NAME modülünün iş mantığını ve reaktif durumunu yöneten denetleyici.
class PASCAL_NAMEController {
  late final ValueNotifier<PASCAL_NAMEModel> state;

  PASCAL_NAMEController({PASCAL_NAMEModel? initialState}) {
    state = ValueNotifier<PASCAL_NAMEModel>(
      initialState ?? PASCAL_NAMEModel.initial(),
    );
  }

  /// Sayacı artırır
  void increment([int step = 1]) {
    final current = state.value;
    state.value = current.copyWith(
      counter: current.counter + step,
      updatedAt: DateTime.now(),
    );
  }

  /// Sayacı azaltır (sıfırın altına inmez)
  void decrement([int step = 1]) {
    final current = state.value;
    final nextVal = (current.counter - step).clamp(0, 999999);
    state.value = current.copyWith(
      counter: nextVal,
      updatedAt: DateTime.now(),
    );
  }

  /// Durumu sıfırlar
  void reset() {
    state.value = PASCAL_NAMEModel.initial(title: state.value.title);
  }

  /// Tamamlanma durumunu değiştirir
  void toggleCompletion() {
    final current = state.value;
    state.value = current.copyWith(
      isCompleted: !current.isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Bellek sızıntılarını önlemek için dinleyiciyi kapatır
  void dispose() {
    state.dispose();
  }
}
EOF
)
CONTROLLER_CONTENT="${CONTROLLER_CONTENT//PASCAL_NAME/${PASCAL_NAME}}"
CONTROLLER_CONTENT="${CONTROLLER_CONTENT//FEATURE_NAME/${FEATURE_NAME}}"
safe_write "$CONTROLLER_FILE" "$CONTROLLER_CONTENT"

# 3. VIEW DOSYASI
VIEW_CONTENT=$(cat << 'EOF'
import 'package:flutter/material.dart';
import '../controllers/FEATURE_NAME_controller.dart';
import '../models/FEATURE_NAME_model.dart';
import '../widgets/FEATURE_NAME_widgets.dart';

class PASCAL_NAMEView extends StatefulWidget {
  const PASCAL_NAMEView({super.key});

  @override
  State<PASCAL_NAMEView> createState() => _PASCAL_NAMEViewState();
}

class _PASCAL_NAMEViewState extends State<PASCAL_NAMEView> {
  late final PASCAL_NAMEController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PASCAL_NAMEController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PASCAL_NAME'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Sıfırla',
            onPressed: _controller.reset,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<PASCAL_NAMEModel>(
          valueListenable: _controller.state,
          builder: (context, data, _) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PASCAL_NAMESummaryCard(data: data),
                  const Spacer(),
                  PASCAL_NAMEActionButtons(
                    onIncrement: _controller.increment,
                    onDecrement: _controller.decrement,
                    onToggle: _controller.toggleCompletion,
                    isCompleted: data.isCompleted,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
EOF
)
VIEW_CONTENT="${VIEW_CONTENT//PASCAL_NAME/${PASCAL_NAME}}"
VIEW_CONTENT="${VIEW_CONTENT//FEATURE_NAME/${FEATURE_NAME}}"
safe_write "$VIEW_FILE" "$VIEW_CONTENT"

# 4. WIDGETS DOSYASI
WIDGET_CONTENT=$(cat << 'EOF'
import 'package:flutter/material.dart';
import '../models/FEATURE_NAME_model.dart';

/// Özet bilgi kartı (40 satır kuralına uygun, const dostu)
class PASCAL_NAMESummaryCard extends StatelessWidget {
  final PASCAL_NAMEModel data;

  const PASCAL_NAMESummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              data.title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${data.counter}',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Chip(
              avatar: Icon(
                data.isCompleted ? Icons.check_circle : Icons.pending_outlined,
                size: 18,
                color: data.isCompleted ? Colors.green : colorScheme.primary,
              ),
              label: Text(data.isCompleted ? 'Tamamlandı' : 'Devam Ediyor'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aksiyon butonları çubuğu (40 satır kuralına uygun)
class PASCAL_NAMEActionButtons extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onToggle;
  final bool isCompleted;

  const PASCAL_NAMEActionButtons({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.onToggle,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove),
                label: const Text('Azalt'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onIncrement,
                icon: const Icon(Icons.add),
                label: const Text('Artır'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          onPressed: onToggle,
          icon: Icon(isCompleted ? Icons.undo : Icons.done_all),
          label: Text(isCompleted ? 'Geri Al' : 'Tamamla'),
        ),
      ],
    );
  }
}
EOF
)
WIDGET_CONTENT="${WIDGET_CONTENT//PASCAL_NAME/${PASCAL_NAME}}"
WIDGET_CONTENT="${WIDGET_CONTENT//FEATURE_NAME/${FEATURE_NAME}}"
safe_write "$WIDGET_FILE" "$WIDGET_CONTENT"

# 5. TEST DOSYASI
TEST_CONTENT=$(cat << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/FEATURE_NAME/controllers/FEATURE_NAME_controller.dart';

void main() {
  group('PASCAL_NAMEController Birim Testleri', () {
    late PASCAL_NAMEController controller;

    setUp(() {
      controller = PASCAL_NAMEController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç değerleri doğrulanmalı', () {
      expect(controller.state.value.counter, 0);
      expect(controller.state.value.isCompleted, false);
    });

    test('increment sayacı doğru artırmalı', () {
      controller.increment(1);
      expect(controller.state.value.counter, 1);

      controller.increment(4);
      expect(controller.state.value.counter, 5);
    });

    test('decrement sayacı sıfırın altına indirmemeli', () {
      controller.increment(2);
      controller.decrement(1);
      expect(controller.state.value.counter, 1);

      controller.decrement(5);
      expect(controller.state.value.counter, 0);
    });

    test('toggleCompletion durumu tersine çevirmeli', () {
      expect(controller.state.value.isCompleted, false);
      controller.toggleCompletion();
      expect(controller.state.value.isCompleted, true);
      controller.toggleCompletion();
      expect(controller.state.value.isCompleted, false);
    });

    test('reset tüm durumu sıfırlamalı', () {
      controller.increment(10);
      controller.toggleCompletion();
      controller.reset();

      expect(controller.state.value.counter, 0);
      expect(controller.state.value.isCompleted, false);
    });
  });
}
EOF
)
TEST_CONTENT="${TEST_CONTENT//PASCAL_NAME/${PASCAL_NAME}}"
TEST_CONTENT="${TEST_CONTENT//FEATURE_NAME/${FEATURE_NAME}}"
safe_write "$TEST_FILE" "$TEST_CONTENT"

echo ""
echo -e "${COLOR_GREEN}${COLOR_BOLD}🎉 Tebrikler! '${FEATURE_NAME}' modülü başarıyla oluşturuldu.${COLOR_RESET}"
echo -e "${COLOR_CYAN}Sıradaki adımlar:${COLOR_RESET}"
echo -e "  1. Modül bileşenlerini ve sayfayı gözden geçirin:"
echo -e "     - ${COLOR_BOLD}${VIEW_FILE}${COLOR_RESET}"
echo -e "  2. Statik kod analizi yapın: ${COLOR_YELLOW}flutter analyze${COLOR_RESET}"
echo -e "  3. Testleri çalıştırın:      ${COLOR_YELLOW}flutter test ${TEST_FILE}${COLOR_RESET}"
