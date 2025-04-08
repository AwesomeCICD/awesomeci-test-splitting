<?php
use PHPUnit\Framework\TestCase;
use Demo\File29;

class File29Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File29::add(2, 3));
    }
}
