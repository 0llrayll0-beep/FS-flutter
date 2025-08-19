import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Introduction text widget explaining app functionality
class IntroTextWidget extends StatelessWidget {
  const IntroTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main introduction
          Text(
            'Bem-vindo ao Scanner de Placas Pro',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.5.h),

          // Description
          Text(
            'Simplifique a identificação de veículos e o gerenciamento de registros com nossa avançada tecnologia OCR. Escaneie placas de veículos instantaneamente ou digite os detalhes manualmente para acessar registros abrangentes do banco de dados.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),

          SizedBox(height: 2.h),

          // Key benefits
          Text(
            'Principais Recursos:',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),

          SizedBox(height: 1.h),

          _buildFeatureItem(
            context,
            icon: 'camera_alt',
            title: 'Escaneamento OCR',
            description:
                'Reconhecimento instantâneo de placas usando tecnologia avançada de câmera',
          ),

          _buildFeatureItem(
            context,
            icon: 'storage',
            title: 'Consulta no Banco de Dados',
            description:
                'Pesquisa e verificação de registros de veículos em tempo real',
          ),

          _buildFeatureItem(
            context,
            icon: 'edit',
            title: 'Entrada Manual',
            description: 'Registro rápido de veículos e gerenciamento de dados',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
