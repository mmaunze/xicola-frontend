export default [
    {
      title: "Pagamentos",
      icon: { icon: "ri-bank-card-line" },
      children: [
        {
          title: "Matriculas",
          to: { name: "utilizadores" },
          icon: { icon: "ri-bank-card-line" },
        },
        {
          title: "Mensalidades",
          to: { name: "utilizadores-alunos" },
          icon: { icon: "ri-bank-card-2-line" },
        },
        {
          title: "Multas",
          to: { name: "utilizadores-professores" },
          icon: { icon: "ri-bank-card-2-fill" },
        },
  
      ],
    },
  ];
  