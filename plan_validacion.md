# Plan de Validación de Puntos en Criterios

## Objetivo
Implementar validaciones estrictas para prevenir errores en la asignación de puntos en criterios e indicadores.

## Problemas Identificados
1. **Criterios individuales**: No hay límite máximo de 8 puntos por criterio
2. **Total por indicador**: No se valida que la suma de los 3 criterios no exceda 20 puntos
3. **Feedback al usuario**: Faltan mensajes de error claros

## Validaciones Requeridas

### Para Criterios Individuales:
- **Límite máximo**: 8 puntos por criterio
- **Mensaje de error**: "Cada criterio no puede exceder 8 puntos"
- **Acción**: Prevenir entrada o mostrar error inmediato

### Para Totales por Indicador:
- **Límite máximo**: 20 puntos por indicador (suma de 3 criterios)
- **Mensaje de error**: "El total del indicador no puede exceder 20 puntos. Rectifique los datos ingresados"
- **Acción**: Mostrar error y prevenir guardado

## Tareas a Implementar

- [x] 1. Agregar validación en tiempo real para cada campo de puntos
- [x] 2. Implementar validación de total por indicador
- [x] 3. Agregar mensajes de error claros y visibles
- [x] 4. Prevenir guardado cuando hay errores de validación
- [x] 5. Actualizar la interfaz para mostrar estados de error
- [x] 6. Probar todas las validaciones

## Detalles de Implementación

### Validación Individual:
- Validar cada TextField de puntos en tiempo real
- Limitar entrada a máximo 8
- Mostrar borde rojo y mensaje si excede límite

### Validación de Total:
- Calcular suma de los 3 criterios por indicador
- Mostrar error si total > 20
- Actualizar visualmente el estado del indicador

### Estados Visuales:
- **Normal**: Borde gris, sin iconos
- **Error individual**: Borde rojo, icono de advertencia
- **Error de total**: Fondo rojo claro, mensaje prominente
- **Válido**: Borde verde, icono de correcto (opcional)
