<template>
  <div
    class="h-100 d-flex align-center justify-space-between text-medium-emphasis"
  >
    <!-- 👉 Footer: left content -->
    <div class="d-flex align-center text-base">
      &copy;
      {{ new Date().getFullYear() }},
      <a
        href="https://www.mefemasys.co.mz"
        target="_blank"
        rel="noopener noreferrer"
        class="text-primary ms-1"
        >Mefema Systems LDA</a
      >
    </div>

    <!-- 👉 Footer: right content -->
    <span class="d-md-flex gap-x-4 text-primary d-none">
      <a href="https://www.mefemasys.co.mz/licenca" target="noopener noreferrer"
        >Licenca</a
      >

      <a
        href="https://https://www.mefemasys.co.mz/xicola/documentacao/"
        target="noopener noreferrer"
        >Documentacao</a
      >
    </span>
  </div>
</template>
