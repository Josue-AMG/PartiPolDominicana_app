import 'dart:io';

import 'package:app8/database/eventos_dao.dart';
import 'package:app8/database/isar_helper.dart';
import 'package:app8/models/evento.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar/isar.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarHelper.instance.init();
  runApp(App8());
}

//############################################ ACERCA DE ###############################################

class App8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Politics👨🏿‍💼Parties',
      home: classContainer(),
    );
  }
}


//############################################ CONTENEDOR (AQUI SE INSERTAN TODAS LAS PESTAÑAS) ###############################################

class classContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.blue,
          backgroundColor: Colors.blue[900],
          title: const Center(
              child: Text("PartiPolDominicana",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          )),
          bottom: TabBar(
              indicatorColor: const Color.fromARGB(255, 224, 198, 0),
              tabs: [
                const Tab(
                  icon: Icon(color: Colors.white, FontAwesomeIcons.house),
                  child: Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                    icon: Icon(
                        color: Colors.amber[100],
                        FontAwesomeIcons.calendarPlus),
                    child: Text(
                      'Agr. Evento',
                      style: TextStyle(color: Colors.amber[100]),
                    )),
                Tab(
                    icon: Icon(
                        color: Colors.amber[300], FontAwesomeIcons.addressCard),
                    child: Text(
                      'Acerca de',
                      style: TextStyle(color: Colors.amber[300]),
                    )),
              ]),
        ),
        body: TabBarView(
          children: [
            Home(),
            AgregarEvento(),
            const Acerca_de(),
          ],
        ),
      ),
    );
  }
}


//############################################ PESTAÑA PRINSIPAL  HOME ###############################################

class Home extends StatefulWidget {
  Key? get key => super.key;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          children: [
            Image.network(
                'https://listindiario.com/files/vertical_main_image/files/fp/uploads/2023/04/17/64463d4ce5e17.r_d.381-117.jpeg'),
            const Divider(),
            Container(
              width: 360,
              child: const Center(
                child: Text(
                    style: TextStyle(fontSize: 22),
                    'Los partidos políticos de la República Dominicana son los aproximadamente 25 partidos y organizaciones políticas que presentan candidatos en cada proceso electoral en la República Dominicana. De estos, apenas unos pocos se reparten la mayoría de la simpatía del electorado y alrededor de ellos gravita la vida política nacional. De las otras agrupaciones, buena parte acude en alianza o respaldando a los candidatos de alguno de los partidos mayoritarios, en particular en las elecciones presidenciales, o son iniciativas independientes, aisladas y/o recientes de ciudadanos que pretenden crear un nuevo espacio para la expresión de la sociedad civil, pero sin gran arrastre o apoyo del público. \n\n 1. De acuerdo con la Ley Electoral 275-97, un partido mayoritario se considera aquel que ha obtenido al menos un 5% de los votos válidos en las últimas elecciones presidenciales y congresuales. Las principales fuerzas políticas del país, organizadas de acuerdo a su participación en el Congreso, son:\n\n1. El Partido Revolucionario Moderno (PRM) de tendencia socialdemócrata y liberal, de centroizquierda.​\n\n2. El Partido de la Liberación Dominicana (PLD), de orientación socialdemócrata y populista de centroizquierda.\n​\n3. La Fuerza del Pueblo (FP), de orientación progresista y populista de izquierda. '),
              ),
            ),
            const Divider()
          ],
        ),
      ),
    ));
  }
}




//############################################ PESTAÑA AGREGAR EVENTO ###############################################

class AgregarEvento extends StatefulWidget {
  @override
  Key? get key => super.key;
  @override
  _AgregarEventoState createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final titulocontroler = TextEditingController();
  final fechacontroler = TextEditingController();
  final descripcioncontroler = TextEditingController();

  final urlaudiocontroler = TextEditingController();
  final dao = EventoDao();

  List<Evento> eventos = [];
  List<int> ids = [];
  @override
  void initState() {
    super.initState();
    dao.getall().then((value) {
      setState(() {
        eventos = value;
      });
    });
  }

  @override
  void dispose() {
    titulocontroler.dispose();
    fechacontroler.dispose();
    descripcioncontroler.dispose();

    urlaudiocontroler.dispose();
    super.dispose();
  }

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);

    } on PlatformException catch (e) {
      print('Fallo al obtener la imagen: $e'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [


//############################################ Esta es la lista que muestra todos los eventos agregados ###############################################

            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: eventos.length,
                itemBuilder: ((context, index) {
                  final evento = eventos[index];
                  return ListTile(
                    leading: Text("${evento.id}"),
                    title: Text('${evento.title}'),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Center(
                                    child: Container(
                                  height: 650,
                                  child: AlertDialog(
                                    content: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${evento.title}',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Divider(),
                                          Text(
                                            'Descripcion',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Text('${evento.descripcion}'),
                                          Divider(),
                                          Text(
                                            'Imagen',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          
                                          image != null ? Image.file(image!, width: 160, height: 160,) : FlutterLogo(),
                                          Text(
                                            'Aduio',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('${evento.urlaudio}'),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          ButtonBar(
                                            alignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [


//############################################ Este es el boton de salida  ###############################################

                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(
                                                      FontAwesomeIcons.doorOpen,
                                                      color: Colors.blue[900])),


//############################################ Este es el boton de eliminar el registro  ###############################################
                                                      
                                              IconButton(
                                                  onPressed: () {
                                                    dao.deleteOne(evento);
                                                    setState(() {
                                                      eventos.removeWhere(
                                                          (element) =>
                                                              evento.id ==
                                                              element.id);
                                                     ids.removeWhere(
                                                          (element) =>
                                                              evento.id ==
                                                              element); 
                                                    });

                                                    
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(
                                                      FontAwesomeIcons.trashCan,
                                                      color: Colors.red))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                              );
                            });
                      },
                      icon: const Icon(FontAwesomeIcons.eye),
                    ),
                  );
                })),
            const Divider()
          ],
        )),
        floatingActionButton: ButtonBar(
          children: [

//############################################ Este es el boton que abre el formulario para agregar un evento  ###############################################

  
            FloatingActionButton(
                backgroundColor: Colors.blue[900],
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          width: 600,
                          height: 800,
                          child: Column(
                            children: [
                              AlertDialog(
                                  content: Column(children: [
                                const Text("Nuevo Registro",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 45)),
                                const Divider(),
                                TextField(
                                  controller: titulocontroler,
                                  decoration:
                                      const InputDecoration(hintText: 'Titulo'),
                                ),
                                TextField(
                                  controller: fechacontroler,
                                  decoration:
                                      const InputDecoration(hintText: 'Fecha'),
                                ),
                                TextField(
                                  controller: descripcioncontroler,
                                  decoration: const InputDecoration(
                                      hintText: 'Descripcion'),
                                ),
                                
                                
                                ButtonBar(alignment: MainAxisAlignment.spaceBetween,children: [
                                          Text("Inserta la imagen: ", style: TextStyle(color: Colors.grey[700], fontSize: 17),),
                                          IconButton(onPressed: (){pickImage(ImageSource.camera);}, icon: Icon(FontAwesomeIcons.camera, color: Colors.blue[900],)),
                                          IconButton(onPressed: (){pickImage(ImageSource.gallery);}, icon: Icon(FontAwesomeIcons.image, color: Colors.amber[900],)),
                                         
                                          ],), 
                                          Divider(color: Colors.black,),
                                TextField(
                                  controller: urlaudiocontroler,
                                  decoration:
                                      const InputDecoration(hintText: 'Audio'),
                                ),
                                const Divider(
                                  color: Colors.transparent,
                                ),
                                ButtonBar(
                                  children: [

//############################################ Este es el boton que guarda los datos de el formulario ###############################################

                                    ElevatedButton(
                                        onPressed: () async {
                                          Evento evento = Evento()
                                            ..title = titulocontroler.text;
                                          final id = await dao.upsert(evento);
                                          evento.id = id;
                                          evento.fecha = fechacontroler.text;
                                          evento.urlfoto = image.toString();
                                          evento.descripcion =
                                              descripcioncontroler.text;
                                          evento.urlaudio =
                                              urlaudiocontroler.text;

                                          
                                          titulocontroler.clear();
                                          fechacontroler.clear();
                                          descripcioncontroler.clear();
                                          urlaudiocontroler.clear();
                                          
                                          setState(() {
                                            ids.add(id);
                                            eventos.add(evento);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Guardar')),

//############################################ Este es el boton de salida del formulario ###############################################

                                    TextButton(
                                        onPressed: () {
              
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cerrar')),
                                  ],
                                ),
                              ])),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),


//############################################ Este boton abre una alerta donde se cuertiona al usuario de su desicion ###############################################


            FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          height: 230,
                          child: AlertDialog(
                              content: Column(
                            children: [
                              Text(
                                  "Seguro que quieres eliminar todos los eventos registrados⚠️?... (Esta opcion solo sebe ser usada en caso de emergencia 🚨)"),
                              Divider(),
                              ButtonBar( alignment: MainAxisAlignment.spaceEvenly,
                                children: [

//############################################ este boton confirma la accion de eliminar todos los datos ###############################################


                                  ElevatedButton(
                                      onPressed: () {
                                        Evento evento = Evento();
                                        
                                        setState(() {
                                          dao.deleteAll(ids);
                                          eventos.removeWhere((element) =>
                                          evento.id == element.id);
                                          ids = [];
                                          eventos = [];
                                        });
                                        Navigator.of(context).pop();

                                      },
                                      child: Text('Si, Eliminar')),

//############################################ este boton cierra la alerta ###############################################

                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No, Cerrar')),
                                ],
                              )
                            ],
                          )),
                        ),
                      );
                    });
              },
              child: Icon(
                FontAwesomeIcons.trashCan,
                color: Colors.white,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 17, 0),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked);
  }
}


//############################################ PESTAÑA ACERCA DE ###############################################
class Acerca_de extends StatelessWidget {
  const Acerca_de({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            const Divider(
              color: Colors.transparent,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            Image.asset(
              "images/yo.jpg",
              width: 160,
            ),
            Center(
              child: Column(
                children: [
                  const Text(
                    "👨🏿‍💻 Josue Alberto Moreno Guzman ⚽",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Text(
                    "Matricula: 2019-8623",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  Center(
                    child: Container(
                      width: 350,
                      child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue[900]),
                          'La democracia no es solo un sistema político, es un compromiso constante con la igualdad, la justicia y la participación ciudadana; es el reflejo del poder del pueblo para moldear su propio destino.'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
