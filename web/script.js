const viewmodel = new Vue({
    el: '#app',
    data: {
       items: [
      ],
      config: [],
      show: {
      }
    },
    methods: {
        sellItem: function(data, index, isSingle){
            if(isSingle){
                var copyData = {...data}
                copyData.amount = 1
                axios.post("https://pawn/sellitem", JSON.stringify(copyData));
                data.amount -= 1;
            }else{
                var copyData = {...data}
                $.post("https://pawn/sellitem", JSON.stringify(copyData));
                data.amount = 0;
            }
        },
        closeUi: function () {
            axios.post("https://pawn/close")    
        }
    },
    mounted() {
    window.addEventListener('keydown', (e) => {
        if (e.key == 'Escape') {
            axios.post("https://pawn/close")
        }
        });

      window.addEventListener('message', (event)=> {
          d = event.data
          
          switch(d.type)
          {
            case "openPawn":
                $('body').fadeIn();
                viewmodel.items = JSON.parse(d.items);
            break;

            case "closePawn":
                $('body').fadeOut();
            break;
          }
        })
    },
  
  })
  