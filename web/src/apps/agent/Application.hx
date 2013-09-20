/* Copyright (c) 2013 Meep Factory OU */

package apps.agent;

import apps.agent.tasks.*;
import saffron.Data;

class Application {
    private static var tasks : Array<Task> = new Array<Task>();
    
    private static function spawn(task : Task) {
        tasks.push(task);
        task.start();
    }
    
    public static function main() {
        // Configuration
        Data.adapter = Config.mysql_adapter;
        
        // Spawn tasks
        spawn(new Watcher());
        spawn(new Processor());
        spawn(new ImageMagick());
    }
}