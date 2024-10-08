/* eslint-disable */
/* prettier-ignore */
// @ts-nocheck
// Generated by unplugin-vue-router. ‼️ DO NOT MODIFY THIS FILE ‼️
// It's recommended to commit this file.
// Make sure to add this file to your tsconfig.json file as an "includes" or "files" entry.

declare module 'vue-router/auto-routes' {
  import type {
    RouteRecordInfo,
    ParamValue,
    ParamValueOneOrMore,
    ParamValueZeroOrMore,
    ParamValueZeroOrOne,
  } from 'unplugin-vue-router/types'

  /**
   * Route name map generated by unplugin-vue-router
   */
  export interface RouteNamedMap {
    'root': RouteRecordInfo<'root', '/', Record<never, never>, Record<never, never>>,
    '$error': RouteRecordInfo<'$error', '/:error(.*)', { error: ParamValue<true> }, { error: ParamValue<false> }>,
    'forgot-password': RouteRecordInfo<'forgot-password', '/forgot-password', Record<never, never>, Record<never, never>>,
    'login': RouteRecordInfo<'login', '/login', Record<never, never>, Record<never, never>>,
    'not-authorized': RouteRecordInfo<'not-authorized', '/not-authorized', Record<never, never>, Record<never, never>>,
    'register': RouteRecordInfo<'register', '/register', Record<never, never>, Record<never, never>>,
    'utilizadores': RouteRecordInfo<'utilizadores', '/utilizadores', Record<never, never>, Record<never, never>>,
    'utilizadores-estudantes': RouteRecordInfo<'utilizadores-estudantes', '/utilizadores/estudantes', Record<never, never>, Record<never, never>>,
    'utilizadores-estudantes-view-id': RouteRecordInfo<'utilizadores-estudantes-view-id', '/utilizadores/estudantes/view/:id', { id: ParamValue<true> }, { id: ParamValue<false> }>,
    'utilizadores-view-id': RouteRecordInfo<'utilizadores-view-id', '/utilizadores/view/:id', { id: ParamValue<true> }, { id: ParamValue<false> }>,
  }
}
