<script setup>
import Sobre from "@/views/utilizadores/encarregados/detalhes/Sobre.vue";


const route = useRoute("utilizadores-encarregados-detalhes-id"); // Assumindo que o nome da rota é "utilizadores-alunos-detalhes-id"
const userTab = ref(null);
const userData = ref(null);

const token = useCookie("accessToken").value;

const tabs = [
  {
    icon: "ri-coin-line",
    title: "Pagamentos",
    content:
      "Informações sobre os pais ou responsáveis, contacto de emergência e dados relacionados.",
  },

  {
    icon: "ri-group-line",
    title: "Encarregados",
    content:
      "Informações sobre os pais ou responsáveis, contacto de emergência e dados relacionados.",
  },

  {
    icon: "ri-book-line",
    title: "Histórico Académico",
    content:
      "Histórico escolar, disciplinas, notas, e situação académica atual.",
  },

  {
    icon: "ri-calendar-line",
    title: "Frequência",
    content: "Registros de frequência escolar, faltas e justificativas.",
  },
  {
    icon: "ri-award-line",
    title: "Actividades",
    content:
      "Participação em actividades extracurriculares, eventos escolares e prémios ou menções.",
  },
  {
    icon: "ri-file-list-line",
    title: "Documentação",
    content:
      "Documentos importantes como bilhete de identidade, certificado de matrícula e outros arquivos necessários.",
  },
  {
    icon: "ri-file-user-line",
    title: "Observações",
    content:
      "Comentários e observações de professores ou coordenadores sobre o desempenho do aluno.",
  },
];

const fetchEncarregado = async () => {
  try {
    const res = await $api(
      `/encarregados-educacao/encarregado/${route.params.id}`,
      {
        method: "GET",
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (res) {
      userData.value = {
        id: res.id,
        nomeCompleto: res.nomeCompleto,
        dataNascimento: res.dataNascimento,
        distritoNascimento: res.distritoNascimento,
        provinciaNascimento: res.provinciaNascimento,
        nomeDoPai: res.nomeDoPai,
        nomeDaMae: res.nomeDaMae,
        religiao: res.religiao,
        grupoSanguineo: res.grupoSanguineo,
        endereco: res.endereco,
        dataRegisto: res.dataRegisto,
        localTrabalho: res.localTrabalho,
        sectorTrabalho: res.sectorTrabalho,
        bilheteIdentificacao: res.bilheteIdentificacao,
        numeroTelefonePrincipal: res.numeroTelefonePrincipal,
        sexo: res.sexo,
        estado: res.estado,
      };
    } else {
      console.error("Nenhum dado de encarregado encontrado.");
    }
  } catch (err) {
    console.error("Erro ao buscar encarregado:", err);
  }
};

onMounted(() => {
  fetchEncarregado();
});
</script>
<template>
  <VRow v-if="userData">
    <VCol cols="12" md="5" lg="4">
      <Sobre :user-data="userData" />
    </VCol>

    <VCol cols="12" md="7" lg="8">
      <VTabs v-model="userTab" class="v-tabs-pill">
        <VTab v-for="tab in tabs" :key="tab.icon">
          <VIcon start :icon="tab.icon" />
          <span>{{ tab.title }}</span>
        </VTab>
      </VTabs>

      <VWindow
        v-model="userTab"
        class="mt-6 enable-tab-transition"
        :touch="false"
      >
        <VWindowItem>
          <Mensalidades />
        </VWindowItem>

        <VWindowItem>
          <InformacaoFamilia />
        </VWindowItem>

        <VWindowItem>
          <HistoricoAcademico />
        </VWindowItem>

        <VWindowItem>
          <Frequencia />
        </VWindowItem>

        <VWindowItem>
          <Actividades />
        </VWindowItem>

        <VWindowItem>
          <Documentacao />
        </VWindowItem>
      </VWindow>
    </VCol>
  </VRow>

  <div v-else>
    <VAlert type="error" variant="tonal">
      Encarregado {{ route.params.id }} não encontrado!
    </VAlert>
  </div>
</template>
