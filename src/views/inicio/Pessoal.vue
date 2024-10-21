<script setup>
const borderColor = 'rgba(var(--v-border-color), var(--v-border-opacity))'

const total_alunos = ref(0);
const total_utilizadores = ref(0);
const total_professores = ref(0);
const total_funcionarios = ref(0);

const totalUtilizadores = async () => {
  try {
    const res = await $api("/utilizadores/totais", {
      method: "GET",
    });

    total_utilizadores.value = res;
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

const totalAlunos = async () => {
  try {
    const res = await $api("/alunos/totais", {
      method: "GET",
    });

    total_alunos.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const totalprofessores = async () => {
  try {
    const res = await $api("/professores/totais", {
      method: "GET",
    });

    total_professores.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const atualizarDados = () => {
  totalUtilizadores();
  totalprofessores();
  totalAlunos();
};

atualizarDados();

const topicsChartConfig = {
  chart: {
    height: 270,
    type: 'bar',
    toolbar: { show: false },
  },
  plotOptions: {
    bar: {
      horizontal: true,
      barHeight: '70%',
      distributed: true,
      borderRadius: 7,
      borderRadiusApplication: 'end',
    },
  },
  colors: [
    'rgba(var(--v-theme-primary),1)',
    'rgba(var(--v-theme-info),1)',
    'rgba(var(--v-theme-success),1)',
    'rgba(var(--v-theme-secondary),1)',
    'rgba(var(--v-theme-error),1)',
    'rgba(var(--v-theme-warning),1)',
  ],
  grid: {
    borderColor,
    strokeDashArray: 10,
    xaxis: { lines: { show: true } },
    yaxis: { lines: { show: false } },
    padding: {
      top: -35,
      bottom: -12,
    },
  },
  dataLabels: {
    enabled: true,
    style: {
      colors: ['#fff'],
      fontWeight: 500,
      fontSize: '13px',
    },
    offsetX: 0,
    dropShadow: { enabled: false },
    formatter(val, opt) {
      return topicsChartConfig.labels[opt.dataPointIndex]
    },
  },
  labels: [
    'Usuarios',
    'Professores',
    'Alunos',
    'Encarregados',
    'Vue',
    'SEO',
  ],
  xaxis: {
    categories: [
      '6',
      '5',
      '4',
      '3',
      '2',
      '1',
    ],
    axisBorder: { show: false },
    axisTicks: { show: false },
    labels: {
      style: {
        colors: 'rgba(var(--v-theme-on-background), var(--v-disabled-opacity))',
        fontSize: '13px',
      },
      formatter(val) {
        return `${ val }%`
      },
    },
  },
  yaxis: {
    max:  70,
    labels: {
      style: {
        colors: 'rgba(var(--v-theme-on-background), var(--v-disabled-opacity))',
        fontSize: '13px',
      },
    },
  },
  tooltip: {
    enabled: true,
    style: { fontSize: '12px' },
    onDatasetHover: { highlightDataSeries: false },
  },
  legend: { show: false },
}

const topicsChartSeries = [{
  data: [
    total_utilizadores.value,
    total_professores.value, 
    total_alunos.value ,
    12,
    10,
    9,
  ],
}]

const topicsData = [
{
    title: 'Usuarios',
    value: total_utilizadores,
    color: 'success',
  },
  {
    title: 'Professores',
    value: total_professores,
    color: 'primary',
  },
  {
    title: 'Alunos',
    value: total_alunos,
    color: 'info',
  },
  
]

const moreTopics = [
  {
    title: 'Animation',
    value: 12,
    color: 'secondary',
  },
  {
    title: 'Vue',
    value: 10,
    color: 'error',
  },
  {
    title: 'SEO',
    value: 9,
    color: 'warning',
  },
]

const moreList = [
  {
    title: 'Refresh',
    value: 'refresh',
  },
  {
    title: 'Update',
    value: 'update',
  },
  {
    title: 'Share',
    value: 'share',
  },
]
</script>

<template>
  <VCard>
    <VCardItem title="Topic you are interested in">
      <template #append>
        <MoreBtn :menu-list="moreList" />
      </template>
    </VCardItem>

    <VCardText>
      <VRow>
        <VCol
          cols="12"
          sm="6"
        >
          <VueApexCharts
            type="bar"
            height="268"
            :options="topicsChartConfig"
            :series="topicsChartSeries"
            class="mb-md-0 mb-6"
          />
        </VCol>

        <VCol class="d-flex justify-space-around align-start">
          <div class="d-flex flex-column gap-y-12">
            <div
              v-for="topic in topicsData"
              :key="topic.title"
              class="d-flex gap-x-2"
            >
              <VIcon
                icon="ri-circle-fill"
                :color="topic.color"
                size="12"
                class="mt-1"
              />
              <div>
                <div
                  class="text-body-1"
                  style="min-inline-size: 90px;"
                >
                  {{ topic.title }}
                </div>
                <h5 class="text-h5">
                  {{ topic.value }}
                </h5>
              </div>
            </div>
          </div>

          <div class="d-flex flex-column gap-y-12">
            <div
              v-for="topic in moreTopics"
              :key="topic.title"
              class="d-flex gap-x-2"
            >
              <VIcon
                icon="ri-circle-fill"
                :color="topic.color"
                size="12"
                class="mt-1"
              />
              <div>
                <div
                  class="text-body-1"
                  style="min-inline-size: 90px;"
                >
                  {{ topic.title }}
                </div>
                <h5 class="text-h5">
                  {{ topic.value }}
                </h5>
              </div>
            </div>
          </div>
        </VCol>
      </VRow>
    </VCardText>
  </VCard>
</template>
