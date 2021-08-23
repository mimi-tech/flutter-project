import 'package:flutter/material.dart';

class NewSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String?> {
  final option = [
    "harvard University",
    "university of Cambridge",
    "columbia University",
    "university of Oxford",
    "yale University",
    "stanford University",
    "university of Paris (Sorbonne)",
    "university of Chicago",
    "university of Michigan",
    "princeton University",
    "massachusetts Institute of Technology (MIT)",
    "university of California – Berkeley",
    "university of Edinburgh",
    "cornell University",
    "university of Pennsylvania",
    "humboldt University of Berlin",
    "new York University",
    "northwestern University",
    "johns Hopkins University",
    "university of Toronto",
    "city University of New York",
    "university of Vienna",
    "university of Washington",
    "duke University",
    "university of Minnesota – Twin Cities",
    "king’s College London",
    "the University of Texas at Austin",
    "university College London",
    "london School of Economics",
    "university of Wisconsin – Madison",
    "university of Göttingen",
    "university of Glasgow",
    "university of California – Los Angeles",
    "trinity College Dublin",
    "california Institute of Technology",
    "pennsylvania State University",
    'lMU Munich',
    "ohio State University",
    "brown University",
    "leipzig University",
    "university of Southern California",
    "university of Manchester",
    "heidelberg University",
    "university of North Carolina at Chapel Hill",
    "university of Pittsburgh",
    "university of Maryland",
    "leiden University",
    "university of Bucharest",
    "the University of Tokyo",
    "university of Florida",
    "university of Illinois at Urbana-Champaign",
    "lomonosov Moscow State University",
    "university of British Columbia",
    "university of Copenhagen",
    "university of Sydney",
    "college of William & Mary",
    "university of Bonn",
    "university of Melbourne",
    "university of Virginia",
    "saint Petersburg State University",
    "university of Iowa",
    "university of Arizona",
    "imperial College London",
    "rutgers University",
    "purdue University",
    "boston University",
    "michigan State University",
    "friedrich Schiller University Jena",
    "hebrew University of Jerusalem",
    "vanderbilt University",
    "university of Utah",
    "dartmouth College",
    "university of Missouri",
    "carnegie Mellon University",
    "university of Tübingen",
    "uppsala University",
    "university of Zürich",
    "nanyang Technological University",
    "university of Rochester",
    "arizona State University – Tempe",
    "university of Halle-Wittenberg",
    "emory University",
    "rice University",
    "charles University in Prague",
    "case Western Reserve University",
    "university of Leeds",
    "peking University",
    "georgetown University",
    "georgia Institute of Technology",
    "university of Amsterdam",
    "university of Oslo",
    "university of Bristol",
    'university of Alberta',
    'florida State University',
    'university of Freiburg',
    'university of Kansas',
    'mcGill University',
    "university of Oregon",
    "national University of Singapore",
    "york University",
  ];
  final recentOption = [
    "harvard University",
    "university of Cambridge",
    "columbia University",
    "university of Oxford",
    "stanford University",
    "university of Paris (Sorbonne)",
    "university of Chicago",
    "university of Michigan",
    "princeton University",
    "massachusetts Institute of Technology (MIT)",
    "university of California – Berkeley",
    "university of Edinburgh",
    "cornell University",
    "university of Pennsylvania",
    "humboldt University of Berlin",
    "new York University",
    "northwestern University",
    "johns Hopkins University",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentOption
        : option.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.school),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(
                  0,
                  query.length,
                ),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
