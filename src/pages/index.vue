<script setup>


const donutChartColors = {
  donut: {
    series1: "#5BB420",
    series2: "#67CB24",
    series3: "#72E128",
    series4: "#8EE753",
    series5: "#AAED7E",
    series6: "#C7F3A9",
  },
};

const storedUserData = JSON.parse(localStorage.getItem("userData"));

const timeSpendingChartConfig = {
  chart: {
    height: 157,
    width: 130,
    parentHeightOffset: 0,
    type: "donut",
  },
  labels: ["36h", "56h", "16h", "32h", "56h", "16h"],
  colors: [
    donutChartColors.donut.series1,
    donutChartColors.donut.series2,
    donutChartColors.donut.series3,
    donutChartColors.donut.series4,
    donutChartColors.donut.series5,
    donutChartColors.donut.series6,
  ],
  stroke: { width: 0 },
  dataLabels: {
    enabled: false,
    formatter(val) {
      return `${Number.parseInt(val)}%`;
    },
  },
  legend: { show: false },
  tooltip: { theme: false },
  grid: { padding: { top: 0 } },
  plotOptions: {
    pie: {
      donut: {
        size: "75%",
        labels: {
          show: true,
          value: {
            fontSize: "1.125rem",
            color:
              "rgba(var(--v-theme-on-background), var(--v-high-emphasis-opacity))",
            fontWeight: 500,
            offsetY: -15,
            formatter(val) {
              return `${Number.parseInt(val)}%`;
            },
          },
          name: { offsetY: 20 },
          total: {
            show: true,
            fontSize: ".7rem",
            label: "Total",
            color:
              "rgba(var(--v-theme-on-background), var(--v-disabled-opacity))",
            formatter() {
              return "231h";
            },
          },
        },
      },
    },
  },
};

const aulasDadas = [23, 35, 10, 20, 35, 23];
</script>

<template>
  <div>
    <VRow class="py-5 match-height">
      <!-- 👉 Welcome -->
      <VCol
        cols="12"
        md="8"
        :class="$vuetify.display.mdAndUp ? 'border-e' : 'border-b'"
      >
        <div class="pe-3">
          <div class="mb-2">
            <span class="text-h5"> Bem vindo de Volta, </span>
            <span class="text-h4"> {{ storedUserData.nome }} 👋🏻 </span>
          </div>

          <div
            class="text-wrap text-body-1 mb-4"
            style="max-inline-size: 400px;"
          >
          A equipe está de parabéns! O trabalho conjunto está a gerar resultados extraordinários. 
          Continue assim e celebremos juntos as conquistas!
          </div>

          <div
            class="d-flex justify-space-between flex-wrap gap-6 flex-column flex-md-row"
          >
            <div
              v-for="{ title, value, icon, color } in [
                {
                  title: 'Aulas Dadas',
                  value: '34h',
                  icon: customLaptop,
                  color: 'primary',
                },
                {
                  title: 'Aproveitamento Pedagogico',
                  value: '82%',
                  icon: customLightbulb,
                  color: 'info',
                },
                {
                  title: 'Course Completed',
                  value: '14',
                  icon: customCheck,
                  color: 'warning',
                },
              ]"
              :key="title"
            >
              <div class="d-flex">
                <VAvatar
                  variant="tonal"
                  :color="color"
                  rounded
                  size="54"
                  class="text-primary me-4"
                >
                  <VIcon :icon="icon" size="38" />
                </VAvatar>
                <div>
                  <h6 class="text-h6 text-medium-emphasis">
                    {{ title }}
                  </h6>
                  <h4 class="text-h4" :class="`text-${color}`">
                    {{ value }}
                  </h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </VCol>

      <!-- 👉 Time Spending -->
      <VCol cols="12" md="4">
        <div class="d-flex justify-space-between align-center">
          <div class="d-flex flex-column ps-3">
            <h5 class="text-h5 mb-1 text-no-wrap">Progresso do Semestre</h5>
            <div class="mb-6 text-body-1">Relatório Trimestral</div>
            <h4 class="text-h4 mb-2">
              231<span class="text-medium-emphasis">h</span> 14<span
                class="text-medium-emphasis"
                >m</span
              >
            </h4>
            <div>
              <VChip color="success" density="comfortable"> +18.4% </VChip>
            </div>
          </div>
          <div>
            <VueApexCharts
              type="donut"
              height="150"
              width="150"
              :options="timeSpendingChartConfig"
              :series="aulasDadas"
            />
          </div>
        </div>
      </VCol>
    </VRow>

    <VRow class="match-height">
      <VCol cols="12" md="8">
      
        <Pessoal />
      </VCol>

    
      <VCol cols="12" md="4" sm="6">
        <MelhoresAlunos />
      </VCol>

    
      <VCol cols="12" md="4" sm="6">
        <MelhorAproveitamento />
      </VCol>

     
      <VCol cols="12" md="4" sm="6">
        <AcademyUpcomingWebinar />
      </VCol>

    
      <VCol cols="12" md="4" sm="6">
        <ProgressoProvas />
      </VCol>

    
    </VRow>
  </div>
</template>
